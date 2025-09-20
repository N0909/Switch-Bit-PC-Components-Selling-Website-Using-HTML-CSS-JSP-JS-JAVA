package com.switchbit.exceptions;

public class CloseConnectionException extends Exception {

	public CloseConnectionException() {
	}

	public CloseConnectionException(String message) {
		super(message);
	}

	public CloseConnectionException(Throwable cause) {
		super(cause);
	}

	public CloseConnectionException(String message, Throwable cause) {
		super(message, cause);
	}

	public CloseConnectionException(String message, Throwable cause, boolean enableSuppression,
			boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

}
