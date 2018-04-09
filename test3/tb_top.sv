`timescale 1ns/1ps


`define MODULE_A 
`define BAR_ 

`ifdef MODULE_A
module foo ();
    initial begin
        $display("Foo A\n");
    end
endmodule
`else /* `ifdef MODULE_B
module foo ();
    initial begin
        $display("Foo B\n");
    end
endmodule
`else


`ifdef MODULE_C
module foo ();
    initial begin
        $display("Foo C\n");
    end
endmodule
 `else `ifdef MODULE_D
module foo ();
    initial begin
        $display("Foo D\n");
    end
endmodule
`endif
`endif `endif

`endif
*/`endif


module tb_top();
    foo u_foo();
    bar u_bar();

    initial begin
        #1;
        $display("Ending.");
        $finish;
    end
endmodule
