#pragma once

#include <cstddef>

namespace dr{
	template <typename T>
	class vector{
		public:
			explicit vector();															
			explicit vector(const size_t size);
			explicit vector(const size_t size, const T& value);
			explicit vector(const vector& other);
			
			~vector();
			
			inline size_t size(){ return v_size; };
			inline bool empty(){ if(v_size == 0){ return true; } return false; };
			
			void push_back(const T& value);
			void push_back(const T&& value);
			void pop_back();
			
			void clear();
			void erase(const size_t index);
			void erase(const size_t first, const size_t last);
			
			T& operator[](size_t index) const{
				if (index >= v_size) {
        	throw "Invalid index access\n";
    		}
				return *v_arr[index];
    	}
    
    	vector &operator=(const vector &other){
				~vector();
				this.vector(other);
        return *this;
    	}
    	
		private:
			T** v_arr;
			size_t v_size;
			size_t v_capacity;
	};
}

template <typename T>
dr::vector<T>::vector(){
	v_arr = nullptr;
	v_size = 0;
}

template <typename T>
dr::vector<T>::vector(const size_t size){
	v_arr = new T*[size]{nullptr};
	v_size = size;
}

template <typename T>
dr::vector<T>::vector(const size_t size, const T& value){
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
void dr::vector<T>::push_back(const T&& value){
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
    throw "Vector empty\n";
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

template <typename T>
void dr::vector<T>::clear(){
	for (v_size; v_size >= 0 ; --v_size) {
		delete v_arr[v_size];
	}
}

template <typename T>
void dr::vector<T>::erase(const size_t index){
	if (index >= v_size) {
  	throw "Invalid index access\n";
  }
	delete v_arr[index];
	T** new_arr = new T*[v_size];
	for(size_t i = 0; i < v_size; i++){
		if(i == index){
			i++;
		}
		new_arr[i] = v_arr[i];
	}
	v_size--;
}

template <typename T>
void dr::vector<T>::erase(const size_t first, const size_t last){
	if (last >= v_size || first > last) {
  	throw "Invalid index access\n";
  }
  
  for(size_t i = first; i < last; i++){
  	delete v_arr[i];
  }
	T** new_arr = new T*[v_size];
	for(size_t i = 0; i < v_size; i++){
		if(i >= first && i <= last){
			i++;
		} else {
			new_arr[i] = v_arr[i];
		}
	}
	v_size = v_size - (last - first);
}
