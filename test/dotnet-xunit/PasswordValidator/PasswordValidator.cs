// https://auth0.com/blog/xunit-to-test-csharp-code/

using System.Text.RegularExpressions;

namespace Validators.Password
{
  public class PasswordValidator
  {
    public bool IsValid(string password)
    {
      Regex passwordPolicyExpression = new Regex(@"((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#!$%]).{8,20})");
      return passwordPolicyExpression.IsMatch(password);
    }
  }
}
