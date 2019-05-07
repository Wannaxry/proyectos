<?php
declare(strict_types=1);
/**
 * @copyright Copyright 2018, Roeland Jago Douma <roeland@famdouma.nl>
 *
 * @author Roeland Jago Douma <roeland@famdouma.nl>
 *
 * @license AGPL-3.0
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License, version 3,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License, version 3,
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 *
 */

namespace OC\Authentication\Token;

use OC\Authentication\Exceptions\ExpiredTokenException;
use OC\Authentication\Exceptions\InvalidTokenException;
use OC\Authentication\Exceptions\PasswordlessTokenException;

class Manager implements IProvider {

	/** @var DefaultTokenProvider */
	private $defaultTokenProvider;

	/** @var PublicKeyTokenProvider */
	private $publicKeyTokenProvider;

	public function __construct(DefaultTokenProvider $defaultTokenProvider, PublicKeyTokenProvider $publicKeyTokenProvider) {
		$this->defaultTokenProvider = $defaultTokenProvider;
		$this->publicKeyTokenProvider = $publicKeyTokenProvider;
	}

	/**
	 * Create and persist a new token
	 *
	 * @param string $token
	 * @param string $uid
	 * @param string $loginName
	 * @param string|null $password
	 * @param string $name
	 * @param int $type token type
	 * @param int $remember whether the session token should be used for remember-me
	 * @return IToken
	 */
	public function generateToken(string $token,
								  string $uid,
								  string $loginName,
								  $password,
								  string $name,
								  int $type = IToken::TEMPORARY_TOKEN,
								  int $remember = IToken::DO_NOT_REMEMBER): IToken {
		return $this->publicKeyTokenProvider->generateToken(
			$token,
			$uid,
			$loginName,
			$password,
			$name,
			$type,
			$remember
		);
	}

	/**
	 * Save the updated token
	 *
	 * @param IToken $token
	 * @throws InvalidTokenException
	 */
	public function updateToken(IToken $token) {
		$provider = $this->getProvider($token);
		$provider->updateToken($token);
	}

	/**
	 * Update token activity timestamp
	 *
	 * @throws InvalidTokenException
	 * @param IToken $token
	 */
	public function updateTokenActivity(IToken $token) {
		$provider = $this->getProvider($token);
		$provider->updateTokenActivity($token);
	}

	/**
	 * @param string $uid
	 * @return IToken[]
	 */
	public function getTokenByUser(string $uid): array {
		$old = $this->defaultTokenProvider->getTokenByUser($uid);
		$new = $this->publicKeyTokenProvider->getTokenByUser($uid);

		return array_merge($old, $new);
	}

	/**
	 * Get a token by token
	 *
	 * @param string $tokenId
	 * @throws InvalidTokenException
	 * @return IToken
	 */
	public function getToken(string $tokenId): IToken {
		try {
			return $this->publicKeyTokenProvider->getToken($tokenId);
		} catch (ExpiredTokenException $e) {
			throw $e;
		} catch(InvalidTokenException $e) {
			// No worries we try to convert it to a PublicKey Token
		}

		//Convert!
		$token = $this->defaultTokenProvider->getToken($tokenId);

		try {
			$password = $this->defaultTokenProvider->getPassword($token, $tokenId);
		} catch (PasswordlessTokenException $e) {
			$password = null;
		}

		return $this->publicKeyTokenProvider->convertToken($token, $tokenId, $password);
	}

	/**
	 * Get a token by token id
	 *
	 * @param int $tokenId
	 * @throws InvalidTokenException
	 * @return IToken
	 */
	public function getTokenById(int $tokenId): IToken {
		try {
			return $this->publicKeyTokenProvider->getTokenById($tokenId);
		} catch (ExpiredTokenException $e) {
			throw $e;
		} catch (InvalidTokenException $e) {
			return $this->defaultTokenProvider->getTokenById($tokenId);
		}
	}

	/**
	 * @param string $oldSessionId
	 * @param string $sessionId
	 * @throws InvalidTokenException
	 */
	public function renewSessionToken(string $oldSessionId, string $sessionId) {
		try {
			$this->publicKeyTokenProvider->renewSessionToken($oldSessionId, $sessionId);
		} catch (ExpiredTokenException $e) {
			throw $e;
		} catch (InvalidTokenException $e) {
			$this->defaultTokenProvider->renewSessionToken($oldSessionId, $sessionId);
		}
	}

	/**
	 * @param IToken $savedToken
	 * @param string $tokenId session token
	 * @throws InvalidTokenException
	 * @throws PasswordlessTokenException
	 * @return string
	 */
	public function getPassword(IToken $savedToken, string $tokenId): string {
		$provider = $this->getProvider($savedToken);
		return $provider->getPassword($savedToken, $tokenId);
	}

	public function setPassword(IToken $token, string $tokenId, string $password) {
		$provider = $this->getProvider($token);
		$provider->setPassword($token, $tokenId, $password);
	}

	public function invalidateToken(string $token) {
		$this->defaultTokenProvider->invalidateToken($token);
		$this->publicKeyTokenProvider->invalidateToken($token);
	}

	public function invalidateTokenById(string $uid, int $id) {
		$this->defaultTokenProvider->invalidateTokenById($uid, $id);
		$this->publicKeyTokenProvider->invalidateTokenById($uid, $id);
	}

	public function invalidateOldTokens() {
		$this->defaultTokenProvider->invalidateOldTokens();
		$this->publicKeyTokenProvider->invalidateOldTokens();
	}

	/**
	 * @param IToken $token
	 * @param string $oldTokenId
	 * @param string $newTokenId
	 * @return IToken
	 * @throws InvalidTokenException
	 */
	public function rotate(IToken $token, string $oldTokenId, string $newTokenId): IToken {
		if ($token instanceof DefaultToken) {
			try {
				$password = $this->defaultTokenProvider->getPassword($token, $oldTokenId);
			} catch (PasswordlessTokenException $e) {
				$password = null;
			}

			return $this->publicKeyTokenProvider->convertToken($token, $newTokenId, $password);
		}

		if ($token instanceof PublicKeyToken) {
			return $this->publicKeyTokenProvider->rotate($token, $oldTokenId, $newTokenId);
		}

		throw new InvalidTokenException();
	}

	/**
	 * @param IToken $token
	 * @return IProvider
	 * @throws InvalidTokenException
	 */
	private function getProvider(IToken $token): IProvider {
		if ($token instanceof DefaultToken) {
			return $this->defaultTokenProvider;
		}
		if ($token instanceof PublicKeyToken) {
			return $this->publicKeyTokenProvider;
		}
		throw new InvalidTokenException();
	}


	public function markPasswordInvalid(IToken $token, string $tokenId) {
		$this->getProvider($token)->markPasswordInvalid($token, $tokenId);
	}

	public function updatePasswords(string $uid, string $password) {
		$this->defaultTokenProvider->updatePasswords($uid, $password);
		$this->publicKeyTokenProvider->updatePasswords($uid, $password);
	}


}
