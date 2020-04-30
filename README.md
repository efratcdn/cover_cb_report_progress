# cover_cb_report_progress
* Title       : Report of no coverage progress  
* Version     : 1.0
* Requires    : Specman {20.03...}
* Modified    : April 2020
* Description :

This directory contains three files:

    e_util_report_no_cover_progress.e  : Implementing the utility
    example_report_no_cover_progress.e : Example of using the utility 
    sample_env.e                       : Basic "testbench", used by the
                                          example

[ More e examples in https://github.com/efratcdn/spmn-e-utils ]

Running the demo:

   specman -c 'load example_report_no_cover_progress.e ; test'

This utility is implemented using the coverage callback api. 
It notifies if the grade of specified coverage had not been changed for 
several sampling.

When the coverage grade does not change, you might conclude that if this
this indicates that this test is "stuck" in specific area, hence - there 
is no use in continue running it.
Such decision can save hours of running "useless" tests.

This utility is just an example, you can change it in various ways.

Some ideas for changes - 
    - Instead of emitting an event, can write to an external data base 
      to be analyzed post run.
    - Instead of monitoring group grade, can check grades of specific
      items
    - Consider what to do after first report. Notify again for each 
      sampling with no change? (as done here) Or stop notifications for
      this group? Restart the counting?
    - Check the grade of specified instance (here we look at the per-type
      grade)
 
  
