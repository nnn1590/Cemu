/*
   Copyright (c) 2011-2016  mingw-w64 project

   Permission is hereby granted, free of charge, to any person obtaining a
   copy of this software and associated documentation files (the "Software"),
   to deal in the Software without restriction, including without limitation
   the rights to use, copy, modify, merge, publish, distribute, sublicense,
   and/or sell copies of the Software, and to permit persons to whom the
   Software is furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
   DEALINGS IN THE SOFTWARE.
*/

// This file should be synced with mingw-w64/mingw-w64-libraries/winpthreads/src/thread.(c|h)
// This is needed to get MODULE from pthread_t

#pragma once
#include <setjmp.h>

#ifdef __cplusplus
extern "C" {
#endif

struct _pthread_v {
    unsigned int valid;
    void *ret_arg;
    void *(*func)(void*);
    _pthread_cleanup *clean;
    int nobreak;
    HANDLE h;
    HANDLE evStart;
    pthread_mutex_t p_clock;
    int cancelled : 2;
    int in_cancel : 2;
    int thread_noposix : 2;
    unsigned int p_state;
    unsigned int keymax;
    void **keyval;
    unsigned char *keyval_set;
    char *thread_name;
    pthread_spinlock_t spin_keys;
    DWORD tid;
    int rwlc;
    pthread_rwlock_t rwlq[RWLS_PER_THREAD];
    int sched_pol;
    int ended;
    struct sched_param sched;
    jmp_buf jb;
    struct _pthread_v *next;
    pthread_t x; /* Internal posix handle.  */
};

extern struct _pthread_v *__pth_gpointer_locked(pthread_t id);

#ifdef __cplusplus
}
#endif
