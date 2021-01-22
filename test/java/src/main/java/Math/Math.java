package Math;

/**
 * Hello world!
 *
 */
public class Math
{
  public int add( int firstValue, int secondValue )
  {
    return firstValue + secondValue;
  }

  public int sub( int firstValue, int secondValue )
  {
    return firstValue - secondValue;
  }

  public int mul( int firstValue, int secondValue )
  {
    return firstValue * secondValue;
  }

  public float div( int firstValue, int secondValue )
  {
    if ( secondValue == 0 )
    {
      return 0;
    }
    return firstValue / secondValue;
  }

  public static void main( String[] args )
  {
    System.out.println( "Hello World!" );
  }
}
