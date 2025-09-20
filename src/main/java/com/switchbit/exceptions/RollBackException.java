package com.switchbit.exceptions;

public class RollBackException extends Exception {

	public RollBackException() {}

	public RollBackException(String message) {
		super(message);
	}

	public RollBackException(Throwable cause) {
		super(cause);
	}

	public RollBackException(String message, Throwable cause) {
		super(message, cause);
	}

	public RollBackException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

}
