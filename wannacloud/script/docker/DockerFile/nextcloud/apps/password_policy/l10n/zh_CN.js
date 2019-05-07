OC.L10N.register(
    "password_policy",
    {
    "Password needs to be at least %s characters long" : "密码长度需要至少%s位",
    "Password needs to contain at least one lower and one upper case character." : "密码至少需要包含一个小写字母和一个大写字母。",
    "Password needs to contain at least one numeric character." : "密码至少需要包含一个数字。",
    "Password needs to contain at least one special character." : "密码需要包含至少一个特殊字符。",
    "Password is among the 1,000,000 most common ones. Please make it unique." : "该密码在 100 万个最常见密码中，请选择其他密码。",
    "Password is present in compromised password list. Please choose a different password." : "该密码在禁用的密码列表中，请选择其他密码。",
    "Password policy" : "密码规则",
    "Allows admins to configure a password policy" : "允许管理员配置密码策略",
    "Allow admin to define certain pre-conditions for password, e.g. enforce a minimum length" : "允许管理员定义密码前置条件，比如说强制密码最小长度。",
    "Minimal length" : "最小长度",
    "Forbid common passwords" : "禁止普通密码",
    "Enforce upper and lower case characters" : "强制要求大写和小写字符",
    "Enforce numeric characters" : "强制要求数字字符",
    "Enforce special characters" : "强制要求特殊字符",
    "Check password against the list of breached passwords from haveibeenpwned.com" : "检查密码是否在 haveibeenpwned.com 的泄露密码列表中",
    "This check creates a hash of the password and sends the first 5 characters of this hash to the haveibeenpwned.com API to retrieve a list of all hashes that start with those. Then it checks on the Nextcloud instance if the password hash is in the result set." : "这会创建一个密码哈希，并将此哈希的前5个字符发送到 haveibeenpwned.com 的 API，获取以这些哈希开头的所有哈希列表。然后在 Nextcloud 实例中检查此密码哈希是否在在结果集中。"
},
"nplurals=1; plural=0;");
