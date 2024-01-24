# Notes : Clox

## Challenges chapter 1 

1. Our encoding of line information is hilariously wasteful of memory. Given that a series of instructions often correspond to the same source line, a natural solution is something akin to run-length encoding of the line numbers. Devise an encoding that compress the line information for a series of instructions in the same line. Change `writeChunk()` to write this compressed form, and implement a `getLine()` function that, given the index of an instruction, determines where the instruction occurs.
Hint: its not necessary for getLine() to be particularly efficient, since its called only when a runtime error occurs.

2. Because OP_CONSTANT uses only a single byte for its operand, a chunk may contain up to 256 different constants. That's small enough that people writing real-world code will hit that limit. We could use two or more bytes to store the operand, but that makes every constant instruction take up more space. Most chunks wont need that many unique constants, so that wastes space and sacrifices some locality in the common case to support the rare case.
To balance those two competing aims, many instruction sets feature multiple instructions that perform the same operation but with operands of different sizes. Leave our existing one-byte OP_CONSTANT instruction alone, and define a second OP_CONSTANT_LONG instruction. It stores the operand as a 24-bit number, which should be plenty. Implement this function:
`void writeConstant(Chunk *chunk, Value value, int line)`
It adds a value to chunks constant array and then writes an appropriate instruction to load the constant. Also add support to the disassembler for OP_CONSTANT_LONG instructions. Defining two instructions seems to be the best of both worlds. What sacrifices, if any, does it force on us?

3. Our reallocate() function relies on the C standard library for dynamic memory allocation and freeing. malloc() and free() arent magic. Find a couple of open source implementations of them and explain how they work. How do they keep track of which bytes are allocated and which are free? What is required to allocate a block of memory? Free it? How do they make that efficient? What do they do about fragmentation()?

Hardcode mode: implement reallocate() without calling realloc(), malloc() or free(). You're allowed to call malloc() once, at the beginning of the interpreter's execution to allocate a single big block of memory, which your reallocate() function has access to. It parcels out blobs of memory from that single region, your own personal heap. It's your job to define how it does that.

## Challenges chapter 2 

1. What bytecode instruction sequence would you generate for the following expressions:

1 * 2 + 3 ->  OP_CONSTANT 1 OP_CONSTANT 2 OP_MULTIPLY OP_CONSTANT 3 OP_ADD
1 + 2 * 3  -> OP_CONSTANT 1 OP_CONSTANT 2 OP_CONSTANT 3 OP_MULTIPLY OP_ADD
3 - 2 - 1  -> OP_CONSTANT 3 OP_CONSTANT 2 OP_SUBTRACT OP_CONSTANT 1 OP_SUBTRACT
1 + 2 * 3 - 4 / - 5 -> OP_CONSTANT 1 OP_CONSTANT 2 OP_CONSTANT 3 OP_MULTIPLY OP_ADD OP_CONSTANT 4 OP_SUBTRACT OP_CONSTANT 5 OP_NEGATE OP_DIVIDE

2. If we really wanted a minimal instruction set, we could eliminate either OP_NEGATE or OP_SUBTRACT. Show the bytecode sequence you'd generate for `4 - 3 * - 2`.
First using OP_NEGATE. Then, using OP_SUBTRACT.
Given the above, do you think it makes sense to have both? Why or why not? Are there any other reduntand instructions you would consider including?

NEGATE: OP_CONSTANT 4 OP_CONSTANT 3 OP_NEGATE OP_CONSTANT 2 OP_NEGATE OP_MULTIPLY OP_ADD
SUBTRACT: OP_CONSTANT 4 OP_CONSTANT 0 OP_CONSTANT 3 SUBTRACT OP_CONSTANT 0 OP_CONSTANT 2 OP_SUBTRACT OP_MULTIPLY OP_ADD

3. Our VM's stack has a fixed size, and we don't check if pushing a value overflow it. This means the wrong series of instructions could cause our interpreter to crash or go into undefined behavior. Avoid that by dynamically growing the stack as needed. What are the costs and benefits of doing so?

The benefit is that our stack grow (undefinitely, so it can run out of memory anyway, but the threshold is rlly higher) and we're not limited by 256 anymore, but we have the cost of growing it and shrinking it. Since elements are pushed and popped a lot from the stack, the operation would run more - and cost more.

4. To interpret OP_NEGATE, we pop the operand, negate the value and then push the result. That's a simple implementation but it increments and decrements stackTop unnecessarily, since the stack ends up the same height in the end, It might be faster to simply negate the value in place on the stack and leave stackTop alone. Try that and see if you can measure a performance difference. Are there other instructions where you can do similar optimization?
