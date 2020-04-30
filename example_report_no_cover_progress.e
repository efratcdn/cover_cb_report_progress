File name     : example_report_when_cover_hit.e 
Title         : Coverage callback examples
Project       : Utilities examples
Created       : 2020
              :
Description   :  Demonstrating the report of no cover progress utility.
  
                 Importing the sample env.e, and requesting to get 
                 informed if env.cover_me grade does not change in 5 
                 samplings.
     
                 A grade being stagnated can indicate that there is
                 something in this test preventing it from getting into
                 areas of interest. It "gets stuck" in same area.
  
<'
import e_util_report_no_cover_progress.e;
import sample_env;

// In our example, we want to stop the run If the grade of env.cover_me
// cover group does not change in 5 samplings.
extend cb_notify_cover_hit {
    on no_cover_progress {
        message(LOW, "Coverage grade of env.cover_me was not changed ",
               "I am losing hope for this test. Stop it.");
        start stop_after_delay(100);
    };
    stop_after_delay(delay : uint) @sys.any is {
        wait [delay] * cycle;
        stop_run();
    };
};

extend sys {
    // Instantiate a coverage callback struct
    // (see its implementation in e_util_report_when_cover_hit.e)
    !cb : cb_notify_cover_hit;

    run() is also {
        cb = new;

        // Register the cover_me coverage group to the coverage 
        // callback struct
        cb.register(rf_manager.get_type_by_name("env").
                    as_a(rf_struct).get_cover_group("cover_me"));        
        // Request to notify if the grade of this cover group is
        // stagnated
        cb.register_group("cover_me");
    };
};
'>

