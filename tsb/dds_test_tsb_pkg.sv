package dds_test_tsb_pkg; 
 
integer test_case = 1; // #case for test 
integer in_sample_num = 8000; // #processed input samples 
 
parameter M = 32; // DDS accumulator wordlength
parameter L = 15; // DDS phase truncation wordlength
parameter W = 14; // DDS ROM wordlength
 
endpackage