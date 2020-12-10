#pragma once

#include <cstddef>

namespace dr{
	template <typename T>
	class vector{
		public:
			explicit vector();															
			explicit vector(size_t size);
			explicit vector(size_t size, const T& value);
			explicit vector( const vector& other);
			
			~vector();
			
			inline size_t size(){ return v_size; };
			inline bool empty(){ if(v_size == 0){ return true; } return false; };
			
			void push_back(const T& value);
			void push_back(T&& value);
			void pop_back();
			
			T& operator[](size_t index) const{
				if (index < 0 || index >= v_size) {
        	throw "Invalid index access\n";
    		}
				return *v_arr[index];
    	}
    
    	/*vector &operator=(const dr::vector &object){
      	v_size = other.size();
      	
				v_arr = new T*[v_size];
				for(size_t i = 0; i<v_size; i++){
					v_arr[i] = new T{other[i]};
				}
      	delete []d_arr;
      	v_arr = obj.get_arr();
        return *this;
    	}*/
    	
		private:
			T** v_arr;
			size_t v_size;
			size_t capacity;
	};
}

template <typename T>
dr::vector<T>::vector(){
	v_arr = nullptr;
	v_size = 0;
}

template <typename T>
dr::vector<T>::vector(size_t size){
	v_arr = new T*[size]{nullptr};
	v_size = size;
}

template <typename T>
dr::vector<T>::vector(size_t size, const T& value){
	v_arr = new T*[size];
	v_size = size;
	for(size_t i = 0; i<v_size; i++){
		v_arr[i] = new T{value};
	}
}

template <typename T>
dr::vector<T>::vector(const vector& other){
	v_size = other.size();
	v_arr = new T*[v_size];
	for(size_t i = 0; i<v_size; i++){
		v_arr[i] = new T{other[i]};
	}
}

template <typename T>
dr::vector<T>::~vector(){
	for(size_t i = 0; i < v_size; i++){
		delete v_arr[i];
	}
	delete[] v_arr;
}

template <typename T>
void dr::vector<T>::push_back(const T& value){
	T&& rval = value;
	vector::push_back(rval);
}

template <typename T>
void dr::vector<T>::push_back(T&& value){
	T** new_arr = new T*[v_size+1];
	for(size_t i = 0; i < v_size; i++){
		new_arr[i] = v_arr[i];
	}
	new_arr[v_size] = new T{value};
	delete[] v_arr;
	v_arr = new_arr;
	v_size++;
}

template <typename T>
void dr::vector<T>::pop_back(){
	if (empty()) {
    throw "Empty container\n";
  }
	v_size--;
	delete v_arr[v_size];
	T** new_arr = new T*[v_size];
	for(int i = 0; i < v_size; i++){
		new_arr[i] = v_arr[i];
	}
	delete[] v_arr;
	v_arr = new_arr;
}
