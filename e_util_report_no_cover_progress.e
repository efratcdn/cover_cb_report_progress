File name     : e_util_report_when_cover_hit.e 
Title         : Coverage callback examples
Project       : Utilities examples
Created       : 2020
              :
Description   :  Implementing a utility that notifies there is no
                 change in the grade of a cover group, after multiple
                 samplings.
  
                 Using the coverage callback api.
  
                 See details in the README
   
                 Usage example in example_report_when_cover_hit.e
  
<'
struct group_info {
    group_name              : string; 
    last_grade              : real;
    samples_with_no_change  : uint;
    max_samples_wo_progress : uint;
};

struct cb_notify_cover_hit like cover_sampling_callback {
    !items_of_interest : list of group_info;
    event no_cover_progress;      
    
    // register_group()
    //
    // api to be called by the user of this utility.
    // Register the names of the groups that have to be notified 
    // in case there is no progress in their grade
    register_group(group_name  : string, max : uint = 5) is {
        var group_info : group_info = new with {
            .group_name  = group_name;
            .max_samples_wo_progress = max;
        };
        items_of_interest.add(group_info);
    };
    
    // do_callback()
    //
    // Implement the callback.
    // If the sampled group is in the list of items_of_interest, check
    // the group grade. If it was not changed in last max_samples_wo_progress
    // samplings - issue a notification
    do_callback() is only {
        // Checking the per-type grade
        if is_currently_per_type()  {
        
            var cr_name    := get_current_cover_group().get_name();
            var group_info := items_of_interest.first(.group_name == cr_name);
            if group_info != NULL {        
                if group_info.last_grade == get_current_group_grade() {
                    group_info.samples_with_no_change += 1;
                } else {
                    group_info.last_grade = get_current_group_grade();
                    group_info.samples_with_no_change = 0;
                };
                if group_info.samples_with_no_change >
                  group_info.max_samples_wo_progress {
                    message(LOW, "The cover group ", cr_name,
                            " grade was not changed in the last ",
                            group_info.samples_with_no_change, " samples " );
                    emit no_cover_progress;
                };
            };
        };
    };
};

'>

