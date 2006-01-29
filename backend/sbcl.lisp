;;;; $Id$
;;;; $Source$

;;;; See LICENSE for licensing information.

(in-package :usocket)

(defun handle-condition (condition &optional (socket nil))
  "Dispatch correct usocket condition."
  (typecase condition
    (condition (error 'usocket-error
                      :real-condition condition
                      :socket socket))))

(defun socket-create (&optional (type :stream))
  "Connect to `host' on `port'.  `host' is assumed to be a string of
an IP address represented in vector notation, such as #(192 168 1 1).
`port' is assumed to be an integer.

Returns a socket object."
  (let* ((socket (make-instance 'sb-bsd-sockets:inet-socket
                                :type type :protocol :tcp))
         (stream (sb-bsd-sockets:socket-make-stream socket)))
    (make-instance 'usocket :stream stream :socket socket)))

(defmethod socket-bind ((usocket usocket)
                        &key (local-host "localhost")
                             (local-port 0)
                             (reuse-address t))
  (with-slots (usocket)
       socket
;;  (setf (sockopt-reuseaddress socket) reuse-address)
     (setf socket

(defmethod socket-connect (host port)
    (handler-case (sb-bsd-sockets:socket-connect socket host port)
      (condition (condition) (handle-condition condition usocket)))
    usocket))

(defmethod socket-close ((socket socket))
  "Close socket."
  (handler-case (sb-bsd-sockets:socket-close (real-socket socket))
    (condition (condition) (handle-condition condition socket))))

(defmethod socket-read-line ((socket socket))
  (cl:read-line (real-stream socket)))

(defmethod socket-write-sequence ((socket socket) sequence)
  (cl:write-sequence sequence (real-stream socket)))

(defun get-host-by-address (address)
  (handler-case (sb-bsd-sockets::host-ent-name
                 (sb-bsd-sockets:get-host-by-address address))
    (condition (condition) (handle-condition condition))))

(defun get-host-by-name (name)
  (handler-case (sb-bsd-sockets::host-ent-addresses
                 (sb-bsd-sockets:get-host-by-name name))
    (condition (condition) (handle-condition condition))))
