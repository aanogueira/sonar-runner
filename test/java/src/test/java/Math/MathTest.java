package Math;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
* Unit test for simple App.
*/
public class MathTest
  extends TestCase
{
  /**
    * Create the test case
    *
    * @param testName name of the test case
    */
  public MathTest( String testName )
  {
    super( testName );
  }

  /**
    * @return the suite of tests being tested
    */
  public static Test suite()
  {
    return new TestSuite( MathTest.class );
  }

  /**
    * Rigourous Test :-)
    */
  public void testApp()
  {
    assertTrue( true );
  }

  public void testAdd()
  {
    Math math = new Math();
    int result = math.add(1, 2);
    assertTrue(result == 3);
  }

  public void testSub()
  {
    Math math = new Math();
    int result = math.sub(4, 2);
    assertTrue(result == 2);
  }

  public void testMul()
  {
    Math math = new Math();
    int result = math.mul(2, 2);
    assertTrue(result == 4);
  }

  public void testDiv()
  {
    Math math = new Math();
    float result = math.div(4, 2);
    assertTrue(result == 2);
  }
}
