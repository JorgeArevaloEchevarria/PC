
#include "sched.h"

static task_t* pick_next_task_fcfs(runqueue_t* rq) {
    task_t* t=head_slist(&rq->tasks);
    
    if (t) {
        /* Current is not on the rq*/
        remove_slist(&rq->tasks,t);
        t->on_rq=FALSE;
        rq->cur_task=t;
    }
    
    return t;
}

static void enqueue_task_fcfs(task_t* t,runqueue_t* rq, int preempted) {

    struct fcfs_data* cs_data=(struct fcfs_data*) t->tcs_data;
    
    if (t->on_rq || is_idle_task(t))
    return;
    
    insert_slist(&rq->tasks,t); //Push task
    t->on_rq=TRUE;

    
    /* If the task was not runnable before on this RQ (just changed the status)*/
    if (!preempted){
        rq->nr_runnable++;
        t->last_cpu = rq->cpu_rq;
    }
}


static void task_tick_fcfs(runqueue_t* rq){
    
    task_t* current=rq->cur_task;
    
    if (is_idle_task(current))
        return;
    
    if (current->runnable_ticks_left==1)
        rq->nr_runnable--; // The task is either exiting or going to sleep right now
}

static task_t* steal_task_fcfs(runqueue_t* rq){
    task_t* t=tail_slist(&rq->tasks);
    
    if (t) {
        remove_slist(&rq->tasks,t);
        t->on_rq=FALSE;
        rq->nr_runnable--;
    }
    return t;
}


sched_class_t fcfs_sched={
    .pick_next_task=pick_next_task_fcfs,
    .enqueue_task=enqueue_task_fcfs,
    .task_tick=task_tick_fcfs,
    .steal_task=steal_task_fcfs
};
