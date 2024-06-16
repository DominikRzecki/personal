//
// Created by dominik on 5/4/23.
//

#pragma once

#include <array>
#include <ostream>
#include <complex>
#include <bit>
#include <cstring>

namespace dr::math {
    /*
     * Deriving from std::array for simplicity and ease of use, instead of using a conventional array.
     * std::array is a lightweight wrapper for c-style arrays.
     *
     * Because VLAs(Variable length arrays) are not supported by the c++ standard, only by some compilers, math::vector doesn't support them neither.
     * The size of your vector has to be known at compile-time!
    */

    template<class T>
    class complex : public std::array<T, 2> {
    public:

        //complex(dr::math::vector<T, 2>& vec) {};
        T length() {
            T sum_of_squares {0};
            for(auto& i : *this)
                sum_of_squares += (i * i);

            return std::sqrt(sum_of_squares);
        }

        T phase() {
            return atan(im/re);
        }

        template <class T1>
        auto operator*(dr::math::complex<T>& other) {
            return dr::math::complex<decltype((std::numeric_limits<T>::max() > std::numeric_limits<T1>::max())? *this : other)&>{this->re * other.re + -this->im * other.im, this->re * other.im + this->im * other.re};
        }

        T& re = this->data()[0];
        T& im = this->data()[1];

    private:

        //Overriding << operator for usage in ostream classes
        template <typename Type>
        friend std::ostream& operator<<(std::ostream& os, const dr::math::complex<Type>& complex);
    };

    template <typename Type>
    std::ostream& operator<<(std::ostream& os, const dr::math::complex<Type>& complex){
        os << complex.re_ << (complex.im_ < 0) ? '-' : '+' << 'j' << abs(complex.im_) << '\n';
        return os;
    }
}
