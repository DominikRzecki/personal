/*
 * Implementation of a mathematical - non-resizable vector
 */

#include <iostream>
#include "../math/vector/vector.h"

template <typename T, size_t N>
using vec = dr::math::vector<T, N>;

//Size of mathematical vectors has to be known at compile-time!
constexpr int A_SIZE = 3;
constexpr int B_SIZE = 3;

int main() {
    dr::math::vector<float, A_SIZE>  a;
    vec<int, B_SIZE> b;

    std::cout<<"Specify all velues of 3-dimensional float vector a: \n";
    for(auto& i : a)
        std::cin >> i;

    std::cout<<"Specify all velues of 2-dimensional int vector b: \n";
    for(auto& i : b)
        std::cin >> i;

    dr::math::vector<float, 2> g{2.0f, 3.0f};

    std::cout<<"vector a: " << a <<"\n";
    std::cout<<"vector b: " << b <<"\n\n";

    std::cout << "sum of vec a: " << a.sum() << "\n";
    std::cout << "sum of vec b: "<< b.sum() << "\n";
    std::cout << "element-wise product: " << a * b << "\n";
    std::cout <<"vector cross product a.x(b): "<< a.cross(b) <<"\n"; //Still needs to be implemented for 4 and more dimensional vectors!
    //std::cout << "dot-product: "<< dr::math::vector<float,2>::dot(a, b) << "\n";
    std::cout <<"element-wise sum of vectors: "<< a + b <<"\n";
    std::cout <<"element-wise difference of vectors: "<< a - b <<"\n";
    std::cout <<"vector a * 2: "<< a * 2 <<"\n";
    std::cout <<"vector b / 2: "<< b / 2 <<"\n";
    std::cout <<"vector a % b: "<< b % 2 <<"\n";
    std::cout <<"unit vector of 'a': "<< a.unit() <<"\n";
    std::cout <<"unit vector of 'a' using the fast inverse square root algorithm (~1% error, 3x faster): "<< a.fast_unit() <<"\n";
    return 0;
}