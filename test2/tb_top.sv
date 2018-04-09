`timescale 1ns/1ps


`define MODULE_D
`define BAR_ 

`ifdef MODULE_A
module foo ();
    initial begin
        $display("Foo A\n");
    end
endmodule
`else `ifdef MODULE_B
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

`ifdef FOO_
   just testing this. this code is wrong.
`endif

`ifndef BAR_
    just testing this. this code is wrong
`endif

`ifndef MODULE_A
    `ifndef MODULE_B
        `ifndef MODULE_C
            `ifndef MODULE_D
            `else
                module bar();
                   initial $display("Bar D\n");
                endmodule
            `endif
         `else
            module bar();
                initial $display("Bar C\n");
            endmodule
         `endif
     `else
     module bar();
        initial $display("Bar B\n");
     endmodule
     `endif
`else    module bar();
        initial $display("Bar A\n");
    endmodule
`endif



module tb_top();
    foo u_foo();
    bar u_bar();

    initial begin
        #1;
        $display("Ending.");
        $finish;
    end
endmodule
