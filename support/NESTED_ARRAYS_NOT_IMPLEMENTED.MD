## UnimplementedFeatureError: Nested arrays not implemented?

### Brief

Nested arrays within Solidity are still incomplete, they do work to a certain degree which creates confusion of where they can and can't be used, as well as what defines a nested array. The concept of a nested array in Solidity doesn't always relate to a primitive definition such as `uint[][]` or `byte[][]`. It encapsulates single dimensional arrays which also contain data types in which they themselves use arrays to store internal values such as `bytes` and `strings`. When referring to primitives in Solidity what is commonly meant is `uint`, `int`, `bool`, `byte` which are in essence are all integers with different lengths. `string`, `bytes` and `address` are just a few examples of data types which contain arrays and therefore implementing a single dimensional array using these data types is in essence a nested array.

### Contents

- [1. Can I use nested arrays?](#1-can-i-use-nested-arrays)
   - [1.1. Where can I use a nested array?](#11-where-can-i-use-a-nested-array)
      - [1.1.1. Internal Nested Uses](#111-internal-nested-uses)
   - [1.2. Where can't I use nested arrays?](#12-where-cant-i-use-nested-arrays)
      - [1.2.1. External Failed Nested Uses](#121-external-failed-nested-uses)
- [2. What does a nested array look like in the storage mechanisms?](#2-what-does-a-nested-array-look-like-in-the-storage-mechanisms)
  - [2.1. Memory](#21-memory)
  - [2.2. Storage](#22-storage)
  - [2.3. Calldata](#23-calldata)
- [3. Alternative Nested Implementation](#3-alternative-nested-implementation)
  - [3.1. Convert a nested array to bytes](#31-convert-a-nested-array-to-bytes)
  - [3.2. Convert bytes to a nested array](#32-convert-bytes-to-a-nested-array)
  - [3.3. Test Case](#33-test-case)
- [4. Resources](4-resources)

### 1. Can I use nested arrays?

In short, yes you can, but you have to understand the constraints of using them before you design your DAPP around them. The first question you want to pose yourself really is do you need them? In Solidity's current state nested arrays are incomplete and will cause you unnecessary challenges. Next, another challenge you should be mindful of is what type of storage will you use for your nested array? Nested arrays are not implemented for every storage type, although they may not throw errors at compilation time you may encounter errors at run time.

#### 1.1. Where can I use a nested array?

We can use nested arrays in several ways at the moment which are pretty exclusive to only internal calling mechanisms. Functions can handle nested arrays, but we can only pass and return nested arrays to functions if they are __not__ externally facing.

##### 1.1.1. Internal Nested Uses

What this basically means is you can use nested array when they have one of the following implementations:

**A storage implementation**

Storage, currently only has the complete and fully functioning implementation of arrays in Solidity.

```
    pragma solidity ^0.4.0;

    contract NestedArrays {
        uint[][] private nested;
        function test() public {}
    }
```

**A memory implementation**

It's important to note; regardless of this both compiling and running fine you cannot add or remove elements to any of the dimensions due to the limits of dynamic arrays in memory.

```
    pragma solidity ^0.4.0;

    contract NestedArrays {
        function test() public {
            uint[][] memory nested;
        }
    }
```

**Or, functionally, with an internal constraint**

Similar to the memory implementation this compiles and runs, but the array length is finite to the length it was passed in as.

```
pragma solidity ^0.4.0;

contract NestedArrays {

    function passNested(uint[][] nested) internal {
        // ...
    }

    function returnNested() internal returns (uint[][]) {
        // ...
    }
}
```

#### 1.2. Where can't I use nested arrays?

Basically, the biggest issue facing nested arrays is with the lack of implementation with the calldata which the compiler will prevent compilation if any interaction is identified. Nested arrays in the calldata may come in later, but for now direct calls are off limits.

##### 1.2.1. External Failed Nested Uses

If you try to use it as part of the call data such as:

**Function parameters**

    pragma solidity ^0.4.0;

    contract NestedArrays {
        function test(uint[][] nested) public {
        }
    }

Will result in the error:

> UnimplementedFeatureError: Nested arrays not yet implemented.

**Or as a return statement**

```
    pragma solidity ^0.4.0;

    contract NestedArrays {
        function test() public returns (uint[][] nested) {
        }
    }
```

Will result in the error:

> UnimplementedFeatureError: Nested dynamic arrays not implemented here.

### 2. What does a nested array look like in the storage mechanisms?

Nested arrays are almost identical in storage, minus a few differences between the lookup techniques.

For the following examples I will use this code to extract the memory

```
pragma solidity ^0.4.0;

contract NestedContract {

    uint[][] nestedArray;

    function outerCall() public returns (uint) {
        nestedArray.push([1,2,3]);
        nestedArray.push([4,5,6]);
        return innerCall(nestedArray);
    }

    function innerCall(uint[][] x) private returns (uint) {
        uint total = 0;
        for(uint i = 0; i < x.length; i++) {
            total += x[i].length;
        }
        return total;
    }
}
```

#### 2.1. Memory

**Memory Block**

The raw memory extracted from the virtual machine debugger Remix.

```
0x120: 00000000000000000000000000000000	????????????????
0x130: 00000000000000000000000000000002	????????????????
0x140: 00000000000000000000000000000000	????????????????
0x150: 00000000000000000000000000000180	????????????????
0x160: 00000000000000000000000000000000	????????????????
0x170: 00000000000000000000000000000200	????????????????
0x180: 00000000000000000000000000000000	????????????????
0x190: 00000000000000000000000000000003	????????????????
0x1a0: 00000000000000000000000000000000	????????????????
0x1b0: 00000000000000000000000000000001	????????????????
0x1c0: 00000000000000000000000000000000	????????????????
0x1d0: 00000000000000000000000000000002	????????????????
0x1e0: 00000000000000000000000000000000	????????????????
0x1f0: 00000000000000000000000000000003	????????????????
0x200: 00000000000000000000000000000000	????????????????
0x210: 00000000000000000000000000000003	????????????????
0x220: 00000000000000000000000000000000	????????????????
0x230: 00000000000000000000000000000004	????????????????
0x240: 00000000000000000000000000000000	????????????????
0x250: 00000000000000000000000000000005	????????????????
0x260: 00000000000000000000000000000000	????????????????
0x270: 00000000000000000000000000000006	????????????????
```
**Memory Layout**

The breakdown of the memory layout and what each memory address points to.

![https://raw.githubusercontent.com/willitscale/learning-solidity/master/support/images/nested_array_memory_layout.png](https://raw.githubusercontent.com/willitscale/learning-solidity/master/support/images/nested_array_memory_layout.png)

I broke this down into 7 chunks of memory:
1. `0x120 -> 32 bytes`, the first chunk contains the number of arrays stored within the array which is interpreted as the next `n*256` (number of elements times a 256-bit unsigned integer) contains the pointers to the arrays
2. `0x140 -> 32 bytes`, the memory location of the first array which is located at `0x180`
3. `0x160 -> 32 bytes`, the memory location of the second array which is located at `0x200`
4. `0x180 -> 32 bytes`, the number of elements in the first array which is interpreted as the next `n*256` (number of elements times a 256-bit unsigned integer) contains the array values
5. `0x1a0 -> 96 bytes`, the array values of the first array which are in 32 byte chunks
6. `0x200 -> 32 bytes`, the number of elements in the second array which is interpreted as the next `n*256` (number of elements times a 256-bit unsigned integer) contains the array values
7. `0x220 -> 96 bytes`, the array values of the second array which are in 32 byte chunks

#### 2.2. Storage

**Storage Key Pairs**

The storage was extracted from the virtual machine debugger Remix.

```
0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563: Object
key: 0x0000000000000000000000000000000000000000000000000000000000000000
value: 0x0000000000000000000000000000000000000000000000000000000000000002
0x510e4e770828ddbf7f7b00ab00a9f6adaf81c0dc9cc85f1f8249c256942d61d9: Object
key: 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563
value: 0x0000000000000000000000000000000000000000000000000000000000000003
0x356e5a2cc1eba076e650ac7473fccc37952b46bc2e419a200cec0c451dce2336: Object
key: 0x510e4e770828ddbf7f7b00ab00a9f6adaf81c0dc9cc85f1f8249c256942d61d9
value: 0x0000000000000000000000000000000000000000000000000000000000000001
0x753cc8fc5e7a91d93f5643762df5be53185955eb51c3c0c359f950297355ef1f: Object
key: 0x510e4e770828ddbf7f7b00ab00a9f6adaf81c0dc9cc85f1f8249c256942d61da
value: 0x0000000000000000000000000000000000000000000000000000000000000002
0x16151152787d511a0109104b9cb0848c09968cca6441d5b658684169389a5ae1: Object
key: 0x510e4e770828ddbf7f7b00ab00a9f6adaf81c0dc9cc85f1f8249c256942d61db
value: 0x0000000000000000000000000000000000000000000000000000000000000003
0x6c13d8c1c5df666ea9ca2a428504a3776c8ca01021c3a1524ca7d765f600979a: Object
key: 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e564
value: 0x0000000000000000000000000000000000000000000000000000000000000003
0xf16d3fc9e4d4df1e3fe3c7af1379a94a5bf19cc5940c1554d2719cf56425c77e: Object
key: 0x6c13d8c1c5df666ea9ca2a428504a3776c8ca01021c3a1524ca7d765f600979a
value: 0x0000000000000000000000000000000000000000000000000000000000000004
0x62038b33fa3a94c7cdad58c54c724a1823109bfbcf2c2efdef975d848c0f5278: Object
key: 0x6c13d8c1c5df666ea9ca2a428504a3776c8ca01021c3a1524ca7d765f600979b
value: 0x0000000000000000000000000000000000000000000000000000000000000005
0xecc633c6a2927a44ba98c5384153a2a399867d7e2916e11988fd95f71cd9c46b: Object
key: 0x6c13d8c1c5df666ea9ca2a428504a3776c8ca01021c3a1524ca7d765f600979c
value: 0x0000000000000000000000000000000000000000000000000000000000000006
```

**Storage Layout**

The breakdown of the storage layout and how it all links up.

![https://raw.githubusercontent.com/willitscale/learning-solidity/master/support/images/nested_array_storage_layout.png](https://raw.githubusercontent.com/willitscale/learning-solidity/master/support/images/nested_array_storage_layout.png)

Unlike memory, I've split this up into 5 chunks instead of 7 as there is no pointers in storage due to the key/value lookups negating the need for this:
1. `0x000...000`, as previously mentioned in the "Invalid Implicit Conversion" support document storage variables are at top level incrementally referenced by a zero index. As this is the first index it has the key of `0x0` and it contains the length of elements in the array.
2. `keccak256(0x000...000)+0`, size of the first nested array which is referenced by the key of the first dimension array length plus the incremental zero index, or in this case 0.
3. `keccak256(0x290...563)+offset`, the elements of the first nested array which are referenced by; the hash of the first nested array length key, hashed again with `keccak256` and incremented by the zero index offset of the element.
4. `keccak256(0x000...000)+1`, size of the second nested array which is referenced by the key of the first dimension array length plus the incremental zero index, or in this case 1.
5. `keccak256(0x290...564)+offset`, the elements of the second nested array which are referenced by; the hash of the second nested array length key, hashed again with `keccak256` and incremented by the zero index offset of the element.

#### 2.3. Calldata

Currently, there is no implementation of this, but when it is expect the layout to be similar to memory.

### 3. Alternative Nested Implementation

One alternative to directly passing or receiving nested arrays via the calldata is to pass the data as bytes and extract the array data or vice-versa.

#### 3.1. Convert a nested array to bytes

Encode a nested array to bytes:

```
function toBytes(uint[][] _array)
    internal
    returns (bytes _ptr) {
    assembly {
        let num_arrays := mload(_array)
        let total_bytes := 0

        _ptr := mload(0x40) 
        switch lt(_ptr, msize()) 
        case 1 { 
            _ptr := msize()
        }        

        // No data
        jumpi(copy_end, eq(0, num_arrays))

        let array_offset := 0
        let idx_arrays := 0
        let num_elements := 0

        // Find the total amount of elements
        length_start:
        jumpi(length_end, eq(idx_arrays, num_arrays))
        array_offset := mload(add(_array, add(0x20, mul(idx_arrays, 0x20))))
        // Don't use the array in memory after the following, it will mess up the pointers!
        mstore(add(_array, add(0x20, mul(idx_arrays,0x20))), sub(array_offset, _array))
        num_elements := add(num_elements, mload(array_offset))
        idx_arrays := add(idx_arrays, 1)
        jump(length_start)
        length_end:

        let idx_bytes := 0
        total_bytes := add(1, add(mul(2, num_arrays), num_elements))

        // Copy all the data to the byte array
        copy_start:
        jumpi(copy_end, eq(total_bytes, idx_bytes))
        mstore(add(_ptr, add(mul(idx_bytes, 0x20), 0x20)), mload(add(_array, mul(idx_bytes, 0x20))))
        idx_bytes := add(idx_bytes, 1)
        jump(copy_start)
        copy_end:

        // Store the amount of bytes
        mstore(_ptr, mul(total_bytes, 0x20))

        // Set the free memory pointer
        mstore(0x40, add(_ptr, mul(0x20, add(total_bytes, 1))))
    }
}
```

The code above is experimental and has known issues due to the overwriting of the array offset pointers. Also, be aware that this can have quite a high gas cost on large arrays. If you wanted to use this with `string` arrays then a lot of the data sizes and offsets would have to be reduced as string values are stored as `byte` or `uint8` lengths.

#### 3.2. Convert bytes to a nested array

Decode a nested array from bytes:

```
function toArray(bytes _bytes)
    internal
    returns (uint[][] _ptr) {
    assembly {
        // Should probably do a modulo check to see if there is a zero remainder first
        let total_bytes := div(mload(_bytes), 0x20)

        _ptr := mload(0x40) 
        switch lt(_ptr, msize()) 
        case 1 { 
            _ptr := msize()
        }     

        // No data
        jumpi(copy_end, eq(0, total_bytes))

        let start_offset := add(_bytes, 0x20)
        let num_arrays := mload(start_offset)
        let array_offset := 0
        let idx_arrays := 0
        let num_elements := 0

        // Find the total amount of elements
        length_start:
        jumpi(length_end, eq(idx_arrays, num_arrays))
        array_offset := mload(add(start_offset, add(0x20, mul(idx_arrays,0x20))))
        // Correct the pointers
        mstore(add(start_offset, add(0x20, mul(idx_arrays,0x20))), add(_ptr, array_offset))
        num_elements := add(num_elements, mload(array_offset))
        idx_arrays := add(idx_arrays, 1)
        jump(length_start)
        length_end:

        let idx_bytes := 0

        // Copy all the data to the byte array
        copy_start:
        jumpi(copy_end, eq(total_bytes, idx_bytes))
        mstore(add(_ptr, mul(idx_bytes, 0x20)), mload(add(start_offset, mul(idx_bytes, 0x20))))
        idx_bytes := add(idx_bytes, 1)
        jump(copy_start)
        copy_end:

        // Set the free memory pointer
        mstore(0x40, add(_ptr, mul(0x20, total_bytes)))
    }
}
```

Again, this code is experimental, but the logic should be correct.

#### 3.3. Test Case

If you would like a test case for the two data conversion mechanisms above here's a basic concept:

```
contract NestedContract {

    uint[][] nestedArray;

    function getBytes() public returns (uint[]) {
        nestedArray.push([1,2,3]);
        nestedArray.push([4,5,6]);
        return toArray(toBytes(nestedArray))[1]; // Should return the second array
    }

    function toBytes(uint[][] _array) internal returns (bytes _ptr);
    function toArray(bytes _bytes) internal returns (uint[][] _ptr);
}
```

### 4. Resources

- [Solidity ABI Specification](https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI)
- [Remix IDE](https://remix.ethereum.org)
- [Can you return an array or a string from a solidity function call?](http://solidity.readthedocs.io/en/develop/frequently-asked-questions.html#can-you-return-an-array-or-a-string-from-a-solidity-function-call)
