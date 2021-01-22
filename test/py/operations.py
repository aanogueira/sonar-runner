class Math():
  def add(self, firstNumber, secondNumber):
    return firstNumber + secondNumber

  def sub(self, firstNumber, secondNumber):
    return firstNumber - secondNumber

  def mul(self, firstNumber, secondNumber):
    return firstNumber * secondNumber

  def div(self, firstNumber, secondNumber):
    if secondNumber == 0:
      return 0
    return firstNumber / secondNumber

if __name__ == "__main__":
    math = Math()
    print(math.add(2,2))
    print(math.sub(2,2))
    print(math.mul(2,2))
    print(math.div(4,2))
