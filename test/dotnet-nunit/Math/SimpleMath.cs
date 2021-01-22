using System;

namespace Math.Api
{
    public class SimpleMath
    {
        public int add(int a, int b)
        {
            return a + b;
        }

        public int sub(int a, int b)
        {
            return a - b;
        }

        public decimal div(int a, int b)
        {
            if ( b == 0 )
            {
                throw new DivideByZeroException();
            }
            return a / b;
        }

        public decimal mul(int a, int b)
        {
            return a * b;
        }
    }
}
