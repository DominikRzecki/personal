//
// Created by dominik on 11/8/21.
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
    template<class T, std::size_t N>
    class vector : public std::array<T, N> {
    public:

        /*!
         * Vector cross product of two vectors (2D or 3D)
         * @tparam Tother type of other vector
         * @tparam Nother size of other vector
         * @param other other vector
        */
        template<class Tother>
        auto cross(dr::math::vector<Tother, N> &other) {
            static_assert(N >= 2 && N <= 3, "Vector cross product only available in 2 - 3 dimensions! Vector cross product is only possible with n - 1 vectors for n dimensions");

            if constexpr(N == 2) {
                return this->data()[0] * other.data()[1] - this->data()[1] * other.data()[0];
            } else {
                dr::math::vector<decltype(this->data()[0] * other.data()[0]), N> tmp{0};

                size_t offset1{0};
                size_t offset2{0};

                for (size_t i = 0; i < N; i++) {
                    offset1 = 1 + i;
                    offset2 = 2 + i;
                    offset1 += ((offset1 >= N) * -N);
                    offset2 += ((offset2 >= N) * -N);
                    tmp[i] = this->data()[offset1] * other.data()[offset2] -
                             this->data()[offset2] * other.data()[offset1];
                }
                return tmp;
            }
        }

        /*!
         * Vector dot product two vectors
         * @tparam Tother type of other vector
         * @tparam Nother size of other vector
         * @param other other vector
        */
        template<typename Tother, size_t Nother>
        auto dot(dr::math::vector<Tother, Nother> &other) {
            decltype(this->data()[0] * other[0]) tmp{0};

            if constexpr(N > Nother) {
                for (size_t i = 0; i < Nother; i++)
                    tmp += this->data()[i] * other.data()[i];
            } else {
                for (size_t i = 0; i < N; i++)
                    tmp += this->data()[i] * other.data()[i];
            }
            int v;
            return tmp;
        }

        /*!
         * Element-wise Multiplication two vectors
         * @tparam Tother type of other vector
         * @tparam Nother size of other vector
         * @param other other vector
        */
        template<typename Tother, size_t Nother>
        auto operator*(dr::math::vector<Tother, Nother> &other) {
            dr::math::vector<decltype(this->data()[0] * other.data()[0]), (N < Nother) * N + (Nother <= N) * Nother> tmp{0};

            for (size_t i = 0; i < tmp.size(); i++)
                tmp[i] = this->data()[i] * other.data()[i];

            return tmp;
        }

        /*!
         * Element-wise Division two vectors
         * @tparam Tother type of other vector
         * @tparam Nother size of other vector
         * @param other other vector
        */
        template<typename Tother, size_t Nother>
        auto operator/(dr::math::vector<Tother, Nother> &other) {
            dr::math::vector<decltype(this->data()[0] * other.data()[0]), (N < Nother) * N + (N >= Nother) * Nother> tmp{0};

            for (size_t i = 0; i < tmp.size(); i++)
                tmp[i] = this->data()[i] / other.data()[i];

            return tmp;
        }

        /*!
         * Element-wise Modulo two vectors
         * @tparam Tother type of other vector
         * @tparam Nother size of other vector
         * @param other other vector
        */
        template<size_t Nother>
        auto operator%(dr::math::vector<int, Nother> &other) {
            if constexpr(std::is_same<T, int>()) {
                dr::math::vector<decltype(this->data()[0] * other.data()[0]),
                        (N < Nother) * N + (N >= Nother) * Nother> tmp{0};

                for (size_t i = 0; i < tmp.size(); i++)
                    tmp[i] = this->data()[i] % other.data()[i];

                return tmp;
            } else {
                static_assert(std::is_same<T, int>(), "Modulo operations only allowed for integers!");
            }
        }

        /*! Multiplication by a scalar
         * @tparam Tscalar Type of scalar
         * @param scalar  scalar
         */
        template<typename Tscalar>
        auto operator*(Tscalar scalar) {
            dr::math::vector<decltype(this->data()[0] * scalar), N> tmp{0};
            for (size_t i = 0; i < tmp.size(); i++)
                tmp[i] = (*this)[i] * scalar;
            return tmp;
        }

        /*! Division by a scalar
         * @tparam Tscalar Type of scalar
         * @param scalar  scalar
         * @returns dr::math::vector
         */
        template<typename Tscalar>
        auto operator/(Tscalar scalar) {
            dr::math::vector<decltype(this->data()[0] * scalar), N> tmp{0};
            for (size_t i = 0; i < tmp.size(); i++)
                tmp[i] = (*this)[i] / scalar;
            return tmp;
        }

        /*! Mpdulo with a scalar
         * @tparam Tscalar Type of scalar
         * @param scalar  scalar
         * @returns dr::math::vector
         */
        auto operator%(int scalar) {
            dr::math::vector<decltype(this->data()[0] * scalar), N> tmp{0};
            for (size_t i = 0; i < tmp.size(); i++)
                tmp[i] = (*this)[i] % scalar;
            return tmp;
        }

        /*! Adding a scalar
         * @tparam Tscalar Type of scalar
         * @param scalar  scalar
         * @returns dr::math::vector
         */
        template<typename Tscalar>
        auto operator+(Tscalar scalar) {
            dr::math::vector<decltype(this->data()[0] * scalar), N> tmp{0};
            for (auto &i: tmp)
                i += scalar;
            return tmp;
        }

        /*! Subtracting a scalar
         * @tparam Tscalar Type of scalar
         * @param scalar  scalar
         * @returns dr::math::vector;
         */
        template<typename Tscalar>
        auto operator-(Tscalar scalar) {
            dr::math::vector<decltype(this->data()[0] * scalar), N> tmp{0};
            for (auto &i: tmp)
                i -= scalar;
            return tmp;
        }

        /*!
         * Element-wise sum two vectors
         * @tparam Tother type of other vector
         * @tparam Nother size of other vector
         * @param other other vector
        */
        template<typename Tother, size_t Nother>
        auto operator+(dr::math::vector<Tother, Nother> &other) {
            dr::math::vector<decltype(this->data()[0] * other[0]), (N < Nother) * N + (Nother <= N) * Nother> tmp{0};

            for (size_t i = 0; i < tmp.size(); i++)
                tmp[i] = (*this)[i] + other[i];

            return tmp;
        }

        /*!
         * Element-wise difference two vectors
         * @tparam Tother type of other vector
         * @tparam Nother size of other vector
         * @param other other vector
        */
        template<typename Tother, size_t Nother>
        auto operator-(dr::math::vector<Tother, Nother> &other) {
            dr::math::vector<decltype(this->data()[0] * other[0]), (N < Nother) * N + (Nother <= N) * Nother> tmp{0};

            for (size_t i = 0; i < tmp.size(); i++)
                tmp[i] = (*this)[i] - other[i];
            return tmp;
        }

        /// @returns sum of vector;
        T sum() {
            T sum = 0;
            for(auto& i : *this)
                sum += i;

            return sum;
        }

        ///@returns length of vector (slow)
        auto length() {
            T sum_of_squares {0};
            for(auto& i : *this)
                sum_of_squares += (i * i);

            return std::sqrt(sum_of_squares);
        }

        ///@returns Length using an inverted fast inverse square root algorithm. (Even tho it is inverting the inverse square root it should still be faster.
        auto fast_length() {
            T sum_of_squares {0};
            for(auto& i : *this)
                sum_of_squares += (i * i);

            return 1/fast_inverse_sqrt(sum_of_squares);
        }

        ///@returns the unit vector
        inline auto unit() {
            return (*this)*1/length();
        }

        ///@returns the unit vector using the fast inverse square root algorithm (~1% error)
        inline auto fast_unit() {
            T sum_of_squares {0};
            for(auto& i : *this)
                sum_of_squares += (i * i);

            return (*this)*fast_inverse_sqrt(sum_of_squares);
        }

    private:

        static auto fast_inverse_sqrt(float num) {                  //C++ version from wikipedia
            static_assert(std::numeric_limits<float>::is_iec559); // (enable only on IEEE 754)

            float const y = bit_cast<float>(
                    0x5f3759df - (bit_cast<std::uint32_t>(num) >> 1));
            return y * (1.5f - (num * 0.5f * y * y));
        };

        template <class T2, class T1>                               //copied from stackoverflow
        static T2 bit_cast(T1 t1) {
            static_assert(sizeof(T1)==sizeof(T2), "Types must match sizes");
            static_assert(std::is_standard_layout<T1>::value && std::is_trivial<T1>::value, "Requires POD input");
            static_assert(std::is_standard_layout<T2>::value && std::is_trivial<T2>::value, "Requires POD output");

            T2 t2;
            std::memcpy( std::addressof(t2), std::addressof(t1), sizeof(T1) );
            return t2;
        }

        //Overriding << operator for usage in ostream classes
        template <typename Type, size_t Number>
        friend std::ostream& operator<<(std::ostream& os, const dr::math::vector<Type, Number>& vec);
    };

    template <typename Type, size_t Number>
    std::ostream& operator<<(std::ostream& os, const dr::math::vector<Type, Number>& vec){
        os << '[';
        for(size_t i = 0; i < vec.size(); i++)
            os << vec[i] << ((i != vec.size() - 1) ? ", " : "]");

        return os;
    }
}
