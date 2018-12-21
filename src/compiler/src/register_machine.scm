(define (make-register name)
  (let ((contents '*unassigned*))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
	    ((eq? message 'set)
	     (lambda (value) (set! contents value)))
	    (else
	     (error "Unknown request -- REGISTER" message))))
    dispatch))

(define (get-contents register)
  (register 'get))

(define (set-contents! register value)
  ((register 'set) value))

;; (define test-register (make-register 'test))
;; (get-contents test-register) ;; *unassigned*
;; (set-contents! test-register 10)
;; (get-contents test-register) ;; 10

(define (make-stack)
  (let ((s '()))
    (define (push x)
      (set! s (cons x s)))
    (define (pop)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            top)))
    (define (initialize)
      (set! s '())
      'done)
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize) (initialize))
            (else (error "Unknown request -- STACK"
                         message))))
    dispatch))

(define (pop stack)
  (stack 'pop))

(define (push stack value)
  ((stack 'push) value))

;; (define test-stack (make-stack))
;; (pop test-stack) ;;  Empty stack -- POP
;; (push test-stack 1)
;; (pop test-stack) ;;  1
;; (pop test-stack) ;;  Empty stack -- POP
;; (push test-stack 2) ;;
;; (test-stack 'initialize) ;; done
;; (pop test-stack) ;;  Empty stack -- POP

(define (make-new-machine)
  (let ((pc (make-register 'pc)) ;; ָ��Ĵ���
	(flag (make-register 'flag)) ;; ��־�Ĵ���
	(stack (make-stack)) ;; ջ
	(the-instruction-sequence '())) ;; ָ���б�
    (let ((the-ops ;; �����б�
	   (list (list 'initialize-stack
		       (lambda () (stack 'initialize)))))
	  (register-table ;; �Ĵ����б�
	   (list (list 'pc pc) (list 'flag flag))))
      ;; ����µļĴ���
      (define (allocate-register name) 
	(if (assoc name register-table)
	    (error "Multiply defined register: " name)
	    (set! register-table
		  (cons (list name (make-register name))
			register-table)))
	'register-allocated)
      ;; �ӼĴ����б����ض��Ĵ���
      (define (lookup-register name)
	(let ((val (assoc name register-table)))
	  (if val
	      (cadr val)
	      (error "Unknown register:" name))))
      ;; ִ��ָ��
      (define (execute)
	(let ((insts (get-contents pc))) ;; ��� pc �Ĵ�����ֵ
	  (if (null? insts)
	      'done
	      (begin
		((instruction-execution-proc (car insts)))
		(execute)))))
      (define (dispatch message)
	(cond ((eq? message 'start) ;; ��������
	       (set-contents! pc the-instruction-sequence) ;; pc �Ĵ���ָ��ָ���б�
	       (execute)) ;; ִ��ָ��
	      ((eq? message 'install-instruction-sequence) ;; ��װָ���б� 
	       (lambda (seq) (set! the-instruction-sequence seq))) 
	      ((eq? message 'allocate-register) allocate-register) ;; ��ӼĴ���
	      ((eq? message 'get-register) lookup-register) ;; ��ѯ�Ĵ���
	      ((eq? message 'install-operations) ;; ��װ��������
	       (lambda (ops) (set! the-ops (append the-ops ops))))
	      ((eq? message 'stack) stack) ;; ����ջ
	      ((eq? message 'operations) the-ops) ;; ���ز����б�
	      (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

;; ��������
(define (start machine)
  (machine 'start))

;; ��üĴ����е�ֵ
(define (get-register-contents machine register-name)
  (get-contents (get-register machine register-name)))

;; ���üĴ����е�ֵ
(define (set-register-contents! machine register-name value)
  (set-contents! (get-register machine register-name) value)
  'done)

;; ȡָ���Ĵ�����Ϣ
(define (get-register machine reg-name)
  ((machine 'get-register) reg-name))
