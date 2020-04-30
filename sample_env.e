 
  sample_env.e
  
  Just a small "testbench", containing a coverage model.
  Being used to demonstrate the coverage callback capabilities.
  
  See example_report_when_cover_hit.e and e_util_report_when_cover_hit.e 
  
<'

type kind_t     : [AAA_0, BBB_1, CCC_2, DDD_3, EEE_4, FFF_5, GGG_6];
type other_kind : [GOOD_0, BAD_1];

struct trans {
    legal   : bool;
    kind    : kind_t;
    address : uint (bits : 16);
};
unit env {
    cur_trans : trans;
        
    event cover_me;
   
    cover cover_me is  {
        item legal : bool   = cur_trans.legal;
        item kind  : kind_t = cur_trans.kind;
        
        item address : uint (bits : 16) = cur_trans.address using ranges = {
            range([0..10], "low address");
            range([11..0xfff0], "mid address");
            range([0xfff1..0xffff], "high address");
        };
        cross legal, kind, address;
    };
  
};

unit env_2 {
    kind : other_kind;
    event item_ended;
    
    keep soft kind == select {
        90 : GOOD_0;
        10 : BAD_1;
    };
    
    cover item_ended is  {
        item kind;
    };
    on item_ended {
        //out("\nevent emited, kind ", kind);
    };
   
};

extend sys {
    env_1_a : env is instance;
    env_1_b : env is instance;
    env_2   : env_2 is instance;
   

    run() is also {
        start scenario();
    };
    
   
    num_of_iters : int;
    keep soft num_of_iters == 100;

    post_generate() is also {
        set_config(run, tick_max, 1m);
    };
    scenario() @any is {
        raise_objection(TEST_DONE);
        var delay : int;
        for i from 1 to num_of_iters {
            gen delay keeping {it in [177..1777]};
            wait [delay] * cycle;;
            gen env_1_a.cur_trans;
            emit env_1_a.cover_me;
            wait [delay] * cycle;;
            gen env_1_b.cur_trans;
            wait [delay] * cycle;
            gen env_2.kind;
            emit env_2.item_ended;
            wait  cycle;
        };  
        drop_objection(TEST_DONE);
    };
};


'>