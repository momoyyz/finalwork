package com.hotel.page;

public class Reservation {
	private int reservationId;
	private int hotelId;
	private String reservationStart;
	private String reservationEnd;
	private String hotelPrice;
	private String hotelType;
	private String reservationStatic;

	private String reservationName;
	private String reservationPhone;

	private int hotelNum;

	private int userId;

	private String reservationUpTime;

	public int getReservationId() {
		return reservationId;
	}

	public void setReservationId(int reservationId) {
		this.reservationId = reservationId;
	}

	public int getHotelId() {
		return hotelId;
	}

	public void setHotelId(int hotelId) {
		this.hotelId = hotelId;
	}

	public String getReservationStart() {
		return reservationStart;
	}

	public void setReservationStart(String reservationStart) {
		this.reservationStart = reservationStart;
	}

	public String getReservationEnd() {
		return reservationEnd;
	}

	public void setReservationEnd(String reservationEnd) {
		this.reservationEnd = reservationEnd;
	}

	public String getHotelPrice() {
		return hotelPrice;
	}

	public void setHotelPrice(String hotelPrice) {
		this.hotelPrice = hotelPrice;
	}

	public String getHotelType() {
		return hotelType;
	}

	public void setHotelType(String hotelType) {
		this.hotelType = hotelType;
	}

	public String getReservationStatic() {
		return reservationStatic;
	}

	public void setReservationStatic(String reservationStatic) {
		this.reservationStatic = reservationStatic;
	}

	public String getReservationName() {
		return reservationName;
	}

	public void setReservationName(String reservationName) {
		this.reservationName = reservationName;
	}

	public String getReservationPhone() {
		return reservationPhone;
	}

	public void setReservationPhone(String reservationPhone) {
		this.reservationPhone = reservationPhone;
	}

	@Override
	public String toString() {
		return "Reservation [reservationId=" + reservationId + ", hotelId="
				+ hotelId + ", reservationStart=" + reservationStart
				+ ", reservationEnd=" + reservationEnd + ", hotelPrice="
				+ hotelPrice + ", hotelType=" + hotelType
				+ ", reservationStatic=" + reservationStatic
				+ ", reservationName=" + reservationName
				+ ", reservationPhone=" + reservationPhone + "]";
	}

	public int getHotelNum() {
		return hotelNum;
	}

	public void setHotelNum(int hotelNum) {
		this.hotelNum = hotelNum;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getReservationUpTime() {
		return reservationUpTime;
	}

	public void setReservationUpTime(String reservationUpTime) {
		this.reservationUpTime = reservationUpTime;
	}

}
