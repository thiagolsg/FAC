.text
    .globl main

main:
    la $a0, ask             #ask user for integer thats going to be the size of the array
    li $v0, 4
    syscall

    li $v0, 5               #store that int
    syscall
    move $t1,$v0            #size of my array stored in $t1

    la $t0, array           #load address of our array
    li $t2, 0               #counter = 0
    lw $t3,($t0)            #initialize min = array[0]
    lw $t4,($t0)            #initialize max = array[0]


while:
    
    li $v0, 4               #store that int
    syscall
    sw $v0, ($t0)           #store that int in the array


end:    add $t0, $t0, 4         #increment the array to the next index
    add $t2, $t2, 1         #increment the counter by 1
    blt $t2, $t1,while      #branch to while if counter < size of array

endw:
    la $a0,display          # Display "Array is: "
    li $v0,4            
    syscall

    li $t0, 0               # initilize array index value back to 0
    li $t2, 0                # initial size counter back to zero
    la $t0, array            # load address of array back into $t0

 sprint:
    lw $t6,($t0)            #load word into temp $t2
    move $a0, $t6           #store it to a safer place
    li $v0, 1               #print it out
    syscall

    la $a0,space            # Display " "
    li $v0,4            
    syscall

    add $t0, $t0, 4         #increment the array to the next index
    add $t2, $t2, 1         #increment the counter by 1

    blt $t2, $t1,sprint     #branch to while if counter < size of array

    li $t2, 0                # initial size counter back to zero
    la $t0, array            # load address of array back into $t0
    add $t0, $t0, 4         #increment the array to the next index
    add $t2, $t2, 1         #increment the counter by 1


 loop:  lw $t8,($t0)             # t8 = next element in array
    bge $t8, $t3, notMin     #if array element is >= min goto notMin
    move $t3,$t8             #min = array[i]
    j notMax

 notMin: ble $t8,$t4, notMax         #if array element is <= max goto notMax
    move $t4,$t8             #max = array[i]

 notMax:    add $t2,$t2,1            #incr counter
    add $t0,$t0, 4           #go up in index
    bge $t2, $t1,loop        #if counter < size, go to loop

 eprint:
    la $a0,nextline          # Display "\n"
    li $v0,4            
    syscall

    la $a0,min               # Display "min number is "
    li $v0,4            
    syscall

    move $a0, $t3            #displays min number in array
    li $v0,1
    syscall

    la $a0,nextline          # Display "\n"
    li $v0,4            
    syscall

    la $a0,max               # Display "max number is "
    li $v0,4            
    syscall

    move $a0, $t4            #displays max number in array
    li $v0,1
    syscall

    li $v0,10                # End Of Program
    syscall     

.data
array: .space 100
ask: .asciiz "How many numbers will be entered? no more than 15 numbers!: "
intask: .asciiz "Enter an Integer: "
min: .asciiz "The minimum number is: "
max: .asciiz "The maximum number is: "
display: .asciiz "Array: "
space: .asciiz " "
nextline: .asciiz "\n"