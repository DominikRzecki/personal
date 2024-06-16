/*
 * Implementation of a mathematical - non-resizable vector
 */

#include <iostream>
#include "../math/complex/complex.h"

//Size of mathematical vectors has to be known at compile-time!
constexpr int A_SIZE = 3;
constexpr int B_SIZE = 3;

int main() {
    dr::math::complex<float> c0 {0.0f, 1.0f};
    return 0;
}