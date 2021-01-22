import unittest
from operations import Math

class MathTest(unittest.TestCase):
  def addTest(self):
    res = Math.add(self, 2, 3)
    self.assertEqual(res, 5)

  def subTest(self):
    res = Math.sub(self, 2, 1)
    self.assertEqual(res, 1)

  def mulTest(self):
    res = Math.mul(self, 2, 3)
    self.assertEqual(res, 6)

  def divTest(self):
    res = Math.div(self, 4, 2)
    self.assertEqual(res, 2)
