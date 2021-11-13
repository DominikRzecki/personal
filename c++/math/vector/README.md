# <span style="color:red">dr::math::vector</span>
***

This library adds the support for mathematical vectors. (Work in progress)

It aims to support not only real world operations, but also theoretical ones (i.e. cross product of 4 or more dimensional vectors)

dr::math::vector is based on std::array and relies heavily on metaprogramming for simplicity. As of now VLAs are not supported because the c++ standard and std::array doesn't support them either.

## Examples

The example program is located at ```personal/c++/examples/mathematical-vector.cpp```.

## Documentation

### Supported features
| FEATURE | 2D  | 3D | 4D | ... |
--- | --- | --- | --- | ---
| element-wise sum of two vectors (+) | x | x | x | x |
| scalar addition (+) | x | x | x | x |
| element-wise difference of two vectors (-) | x | x | x | x |
| scalar subtraction (-) | x | x | x | x |
| element-wise multiplication of two vectors (*) | x | x | x | x |
| scalar multiplication (*) | x | x | x | x |
| element-wise division of two vectors (/) | x | x | x | x |
| scalar division (/) | x | x | x | x |
| element-wise modulo of two vectors (%) (only with integer vectors) | x | x | x | x |
| scalar modulo (%) (only with integer vectors) | x | x | x | x |
| element-wise sum of two vectors (%) | x | x | x | x |
| cross-product ( .cross() ) | x | x |  |  |
| dot-product ( .dot() ) | x | x | x | x |
| length of vector ( .length() ) | x | x | x | x |
| length of vector using the inverted fast inverse square root algorithm. ( .fast_length() ) | x | x | x | x |
| unit vector ( .unit() ) | x | x | x | x |
| unit vector using the fast inverse square root algorithm. ( .fast_unit() ) | x | x | x | x |

In the future the .dot() and .cross() functions will be made static because cross() needs n-1 vectors for n dimensions (Will be made possible with a Variadic template.) and the code looks cleaner overall.
```c++
    ...
    template <class Tone, class None, class TTwo, class Ntwo>
    static auto dot(dr::math::vector<Tone, None>& one, dr::math::vector<Ttwo, Ntwo>& two)
    ...
    template <class ...Args>
    static auto cross(Args& ...args)
    ...
    
```
It shall be noted that the cross product of more-than-three-dimensional vectors doesn't exist in the real world and thus is only theoretical.
The cross product of two-dimensional ones isn't recognised by the mathematicians either and, but used in computer graphics.

It would be nice to allow the modulo operations for non-integers ut this needs a more complex and performance intensive algorithm.

It might be useful to write a complex-number library and make it compatible with the two-dimensional dr::math::vector. ```(dr::math::vector<T, 2>)```

The sourcecode is documented using doxygen. (Description of each function is in the header file)

*Dominik Rzecki*