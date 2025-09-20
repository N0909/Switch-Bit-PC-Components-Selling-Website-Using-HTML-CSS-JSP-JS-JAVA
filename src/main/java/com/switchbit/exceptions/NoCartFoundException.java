package com.switchbit.exceptions;

public class NoCartFoundException extends Exception {
	public NoCartFoundException(String message) {
		super(message);
	}
	
	public NoCartFoundException(String message, Throwable cause) {
		super(message, cause);
	}
	
	
}
