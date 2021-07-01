extern  _getLocalTime           ;function in C driver program
global  currentTime             ;make this available to C program
        
        ;; -------------------------
        ;; data segment
        ;; -------------------------
        section .data
;;; time structure for int 0x80, 78
currentTime equ $        
tvsec   dd      0               ; number of seconds since midnight
tvusec  dd      0               ; number of useconds

;;; time structure for local time
timeinfo equ    $        
tm_sec  dd      0               ;seconds after the minute 0-61*
tm_min  dd      0               ;minutes after the hour	  0-59
tm_hour dd      0               ;hours since midnight	  0-23
tm_mday dd      0               ;day of the month	  1-31
tm_mon  dd      0               ;months since January	  0-11
tm_year dd      0               ;years since 1900	
tm_wday dd      0               ;days since Sunday	  0-6
tm_yday dd      0               ;days since January 1	  0-365
tm_dst  dd      0               ;Daylight Saving Time flag	        
TIMELEN equ     ($-timeinfo)/4        


        ;; -------------------------
        ;; code area
        ;; -------------------------
        section .text
        global  asm_main
asm_main:       

;;; get the local time in year, month, day, hour, min, sec...
        
        call    getLocalTime    

;;; print a few of the values obtained
        
        mov     eax, [tm_mday]
        call    print_int
        call    print_nl
        
        mov     eax, [tm_mon]
        add     eax, 1          ;because Jan is 0
        call    print_int
        call    print_nl
        
        mov     eax, [tm_year]
        add     eax, 1900       ;because we get an offset since 1900
        call    print_int
        call    print_nl
        
        mov     eax, [tm_hour]
        call    print_int
        call    print_nl
        
        mov     eax, [tm_min]
        call    print_int
        call    print_nl
        
        mov     eax, [tm_sec]
        call    print_int
        call    print_nl
        
        ;; return to C program

        ret        


        
;;; ------------------------------------------------------------------
;;; getTimeOfDay: asks Linux for the # of seconds since Jan 1, 1970.
;;; ------------------------------------------------------------------
getTimeOfDay:
        mov     eax, 78         ; system call: get time of day
        mov     ebx, tvsec      ; address of buffer for secs/usecs
        mov     ecx, 0          ; NULL for timezone
        int     0x80
        ret

;;; ------------------------------------------------------------------
;;; getLocalTime: first gets the time of day, then ask Linux to transform
;;;               this information into month, day, hours, minutes, sec.,
;;;               etc.  The information is stored in the dwords stored at
;;;               timeinfo in the data segment.
;;; ------------------------------------------------------------------
getLocalTime:
;;; get the # of sec since Jan 1, 1970
        call    getTimeOfDay

;;; transform this # of sec into local time
        call    _getLocalTime        ; call the C function
        
        mov     esi, eax
        mov     edi, timeinfo
        mov     ecx, TIMELEN
copyTime:
        mov     eax, [esi]
        mov     [edi],eax
        add     esi, 4
        add     edi, 4
        loop    copyTime

        ret