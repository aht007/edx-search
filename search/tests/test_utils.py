import time
import unittest
from search.utils import measure_time

class TestUtils(unittest.TestCase):
    def test_measure_time(self):
        @measure_time
        def dummy_function():
            time.sleep(1)

        dummy_function()
        self.assertTrue(dummy_function.elapsed_time > 1)
