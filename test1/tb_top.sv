
//This is a comment
module foo;
    int a; //this is a variable
endmodule
/* commenting out this

module foo
    int b;
endmodule
*/

/**/ //empty comment

/* // also checking this case
*/

// /* How about this

module tb_top;    
    initial begin
        $display("Test start");
        $finish();
    end
endmodule
