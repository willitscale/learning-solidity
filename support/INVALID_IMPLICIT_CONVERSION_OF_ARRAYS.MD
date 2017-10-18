## Invalid implicit conversion of arrays from storage to memory and vice-versa

This document outlines some issues with data casting between arrays and their corresponding storage mechanisms. The key issue in most cases raised is looking at casting a fixed length array to a dynamic array.

#### 1. Casting arrays

Casting arrays can be in some cases a simple operation such as point one reference to another, if the two data types have an identical correlation.

##### 1.1. Types of errors you may encounter

> TypeError: Type uint[] memory is not implicitly convertible to expected type uint[] storage ref. 

> TypeError: Invalid type for argument in function call. Invalid implicit conversion from uint[n] storage ref to int[] memory requested.

#### 2. What do arrays look like in memory?

Arrays and their storage types are not all the same and each variant has its own way of storing data.

##### 2.1. Fixed-length array

A fixed-length array is the most primitive type of array we have available within solidity. In code it looks something like this:

```
uint[2] fixedArray;
```

What we're telling the compiler here is that we plan on storing two values which both need to be 256 bits in length (or 32 bytes). Because we have a length known at compile time there is no need for us to store any more information. We are already bound to the constraints of the length and have also defined the size of each length by the data type. When the compiler allocates the memory for a fixed length array it is then reserved and both the number of elements and data type cannot be modified.

###### 2.1.1. Memory Layout

```
-----------------------------------
|     Element    |     Element    |
|       n1       |        n2      |
-----------------------------------
|    32 bytes    |    32 bytes    |
-----------------------------------
|      0x01      |      0x02      |
-----------------------------------
```

Just a sequence of elements of their data type length.

##### 2.2. Dynamic arrays in memory/storage

Although memory and storage use different storage mechanisms (storage is stored as part of the blockchain data and memory in temporary memory on execution), they have the same structure. As we already know that they we are storing a uint of 32 bytes we have no need to store the data size and therefore only need to store the length and values. Here's what a simple dynamic array definition looks like in code:

```
uint[] dynamicArray;
```

In this case we're simply telling the compiler that we have a dynamic array, of a mutable length and we have a fixed data type size. The compiler interprets this as we need to reserve enough memory for the **n** number of elements multiplied by the **s** size of the data type. It's worth noting that at the moment it's not currently possible to modify a dynamic array length which has been created in memory directly e.g.

```
uint[] memory dynamicArrayInMemory;
```

Dynamic arrays are finite in length once in memory due to how arrays are currently stored in Solidity. Basically, if you have a dynamic array which has a incremental growing and shrinking capacity you would either have to; constantly keep shuffling around the memory, risk overwriting existing memory or reserve a large block of memory which is incredibly inefficient and gas heavy. Other programming languages resolved this issue using dictionaries and linked list structures where you reference various memory locations instead of a sequence of memory. The reason why its possible to do in the storage is because it optimizes the storage similar to a linked list, but this hasn't been applied to the use within memory. In short arrays in Solidity are far from complete and need some additional work, so I would consider using other techniques for now.

###### 2.2.1. Memory Layout

```
----------------------------------------------------
|   Length of    |     Element    |     Element    |
|     array      |       n1       |        n2      |
----------------------------------------------------
|    32 bytes    |    32 bytes    |    32 bytes    | 
----------------------------------------------------
|       0x02     |       0x01     |      0x02      |
----------------------------------------------------
```

This time we have an extra length value, but again still a sequence of elements. The only key difference is that this sequence is "mutable".

###### 2.2.2. An array in storage

Arrays in storage as previously mentioned are not in sequence and therefore can grow and shrink without consequence. They use a key reference which is calculated in two ways. The first is by variable index which is the incremental entry (using a zero index) that they get assigned when the contract is constructed which is in a queue like manor. Let's take the following for example:

```
    uint[] _storage1;
    uint[] _storage3;
    uint[] _storage2;
```
We have three storage arrays, if we wanted to access `_storage1` this would be key **0**, `_storage2` would be key **2** and `_storage3` would be key **1**. Basically, it's like an array itself, but this applies to all variables and not just arrays. Accessing elements within the arrays is a little bit more complicated, it's done by a combination of a hash (or keccak256) of the variable index plus the element position `keccak256(idx)+element`. Here's an example of what accessing storage arrays looks like:

```
pragma solidity ^0.4.0;

contract StorageMechanism {

    uint[] _storage1;
    uint[] _storage2;
    uint[] _storage3;
    
    function store() public {
        // Populate the arrays
        _storage1.push(1);
        _storage2.push(2);
        _storage3.push(3);
        _storage2.push(4);
        _storage1.push(2);
        _storage1.push(3);
        _storage1.push(4);
        
        assembly {
            
            let x := sload(0)// Get _storage1 from the array (this will contain the length)
            
            let _ptr := 0x00 // Allocate some scratch memory we can use for a pointer
            mstore(_ptr, 0) // Store our pointer to the _storage1 address
            
            let k := keccak256(_ptr, 0x20) // Generate the key from the index for the first element
            x := sload(k) // Get the first element of _storage1
            
            k := add(keccak256(_ptr, 0x20),1) // Generate the key from the index for the second element
            x := sload(k) // Get the second element of _storage1
            
            sstore(k, 78) // Change the second element of _storage1 to 78
        }
    }
}
```

The storage layout of `_storage1` looks like this:

```
0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563: Object       
    key: 0x0000000000000000000000000000000000000000000000000000000000000000      
    value: 0x0000000000000000000000000000000000000000000000000000000000000004
0x510e4e770828ddbf7f7b00ab00a9f6adaf81c0dc9cc85f1f8249c256942d61d9: Object
    key: 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563
    value: 0x0000000000000000000000000000000000000000000000000000000000000001
0x6c13d8c1c5df666ea9ca2a428504a3776c8ca01021c3a1524ca7d765f600979a: Object
    key: 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e564
    value: 0x0000000000000000000000000000000000000000000000000000000000000002
0x63d75db57ae45c3799740c3cd8dcee96a498324843d79ae390adc81d74b52f13: Object
    key: 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e565
    value: 0x0000000000000000000000000000000000000000000000000000000000000003
0x68ebfc8da80bd809b12832608f406ef96007b3a567d97edcfc62f0f6f6a6d8fa: Object
    key: 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e566
    value: 0x0000000000000000000000000000000000000000000000000000000000000004
```

As you can see the object reference for first element (of key `0x0000000000000000000000000000000000000000000000000000000000000000`) is incremented for the array element values:
- index = **0**, `0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e56`**3** 
- index = **1**, `0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e56`**4**
- index = **2**, `0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e56`**5**
- index = **3**, `0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e56`**6**

###### 2.2.3. An array in memory

In short, you can define, allocate and modify existing values of a dynamic array in memory, but that's as far as you can go with Solidity's current implementation. As previously mentioned arrays (both fixed-length and dynamic) within memory are sequential and therefore become problematic. If we take the following example:

```
// Scratch memory
0x00: 00000000000000000000000000000000	????????????????
0x10: 00000000000000000000000000000000	????????????????
0x20: 00000000000000000000000000000000	????????????????
0x30: 00000000000000000000000000000000	????????????????

// Free memory pointer
0x40: 00000000000000000000000000000000	????????????????
0x50: 00000000000000000000000000000120	????????????????

// The "heap"

// Dynamic array
0x60: 00000000000000000000000000000000	????????????????
0x70: 00000000000000000000000000000004	????????????????
0x80: 00000000000000000000000000000000	????????????????
0x90: 00000000000000000000000000000001	????????????????
0xa0: 00000000000000000000000000000000	????????????????
0xb0: 00000000000000000000000000000002	????????????????
0xc0: 00000000000000000000000000000000	????????????????
0xd0: 00000000000000000000000000000003	????????????????
0xe0: 00000000000000000000000000000000	????????????????
0xf0: 00000000000000000000000000000004	????????????????

// Unsigned integer
0x100: 00000000000000000000000000000000	????????????????
0x110: 00000000000000000000000000000004	????????????????
```

Essentially, our array is defined between `0x60` and `0xff` with this breakdown:
- `0x60` - `0x7f` = Array Size **4**
- `0x80` - `0x9f` = Element `0` with the value of **1** 
- `0xa0` - `0xbf` = Element `1` with the value of **2**
- `0xc0` - `0xdf` = Element `2` with the value of **3**
- `0xe0` - `0xff` = Element `3` with the value of **4**

The problem we have is that if we want to add a fifth value we now have to start moving memory around or overwrite existing memory. To append an element the following steps would have to be performed:
1. Allocate `32 bytes` of memory to the heap
2. Move the unsigned integer forward `32 bytes`
3. Update any references which used the unsigned integer to point now to `0x120` (such as the stack)
4. Increment our array size to 5
5. Add our fifth element to between `0x100` - `0x11f` 
6. Update the free memory pointer to `0x140`

This example is pretty simplistic as there isn't much memory, but if there was a substantial amount of memory after the array then you are realms of memory corruption if not handled correctly. 

##### 2.3. Dynamic array in call data

When handling call data it has a prefix of the data pointer which is important if you're creating an array from inline assembly.

###### 2.3.1. Memory Layout

```
---------------------------------------------------------------------
|      Data      |    Length of   |     Element    |     Element    |
|     Pointer    |      array     |       n1       |        n2      |
---------------------------------------------------------------------
|     32 bytes   |    32 bytes    |    32 bytes    |    32 bytes    | 
---------------------------------------------------------------------
|       0x20     |       0x02     |       0x01     |      0x02      |
---------------------------------------------------------------------
```

Despite the extra 32 bytes for the data pointer, it's still the same mutable sequence of data.

#### 3. Resources

- [Layout of State Variables in Storage](http://solidity.readthedocs.io/en/develop/miscellaneous.html#layout-of-state-variables-in-storage)
- [Layout in Memory](http://solidity.readthedocs.io/en/develop/miscellaneous.html#layout-in-memory)
