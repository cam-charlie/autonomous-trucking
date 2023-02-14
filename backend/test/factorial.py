import unittest

def factorial(n):
    if n <= 1: return 1
    return n * factorial(n-1)

class TestFactorial(unittest.TestCase):
    def test_base_cases(self):
        self.assertEqual(factorial(1), 1)
        self.assertEqual(factorial(0), 1)

    def test_factorial5_is_120(self):
        self.assertEqual(factorial(5), 120)

if __name__ == "__main__":
    unittest.main()