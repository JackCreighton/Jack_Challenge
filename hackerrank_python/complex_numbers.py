import math

class Complex(object):
    real = 0
    imaginary = 0

    def __init__(self, real, imaginary):
        self.real = float(real)
        self.imaginary = float(imaginary)
        
    def __add__(self, no):
        real_result = self.real + no.real
        imaginary_result = self.imaginary + no.imaginary
        return Complex(real_result, imaginary_result)

    def __sub__(self, no):
        real_result = self.real - no.real
        imaginary_result = self.imaginary - no.imaginary
        return Complex(real_result, imaginary_result)
        
    def __mul__(self, no):
        real_result = (self.real * no.real) - (self.imaginary * no.imaginary)
        imaginary_result = (self.real * no.imaginary) + (self.imaginary * no.real)
        return Complex(real_result, imaginary_result)

    # Change to __div__ if using Python 2.x
    def __truediv__(self, no):
        conjugate = Complex(no.real, -1 * no.imaginary)
        denominator = (no.real * no.real) + (no.imaginary * no.imaginary)
        real_result = ((self.real * no.real) + (self.imaginary * no.imaginary)) / denominator
        imaginary_result = ((self.imaginary * no.real) - (self.real * no.imaginary)) / denominator
        return Complex(real_result, imaginary_result)
        
    def mod(self):
        return Complex(math.sqrt((self.real * self.real) + (self.imaginary * self.imaginary)), 0)

    def __str__(self):
        if self.imaginary == 0:
            result = "%.2f+0.00i" % (self.real)
        elif self.real == 0:
            if self.imaginary >= 0:
                result = "0.00+%.2fi" % (self.imaginary)
            else:
                result = "0.00-%.2fi" % (abs(self.imaginary))
        elif self.imaginary > 0:
            result = "%.2f+%.2fi" % (self.real, self.imaginary)
        else:
            result = "%.2f-%.2fi" % (self.real, abs(self.imaginary))
        return result

if __name__ == '__main__':
    infile = open('./input.txt', 'r')
    count = 0
    C = Complex(0, 0)
    D = Complex(0, 0)
    for line in infile.readlines():
        line_split = line.split(" ")
        if count == 0:
            C = Complex(line_split[0], line_split[1])
        elif count == 1:
            D = Complex(line_split[0], line_split[1])
        count += 1

    print(str(C + D))
    print(str(C - D))
    print(str(C * D))
    print(str(C / D))   # Uses __truediv__ instead of __div__ in Python 3.x
    print(str(C.mod()))
    print(str(D.mod()))