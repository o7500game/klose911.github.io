(define (stop? P x)
  ....)

(define (loop-forever x)
  (loop-forever x)) 

;; (stop? loop-forever 1) ; => #f 

(define (diag x)
    (if (stop? x x)
	(loop-forever)
	42))

;; (diag diag)

;; loop-forever ����ζ�� (stop? diag diag) Ϊ�棬���stop? �����Ķ��岻��
;; �������42������ζ��(stop? diag diag) Ϊfalse�����ֺ� stop? �����Ķ��岻��



