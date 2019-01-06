package com.hotel.page;

public class Hotel {
	private int hotelId;
	private int hotelPeople; // 人数
	private int hotelWindow;// 窗户
	private int hotelBreakfas;
	private int hotelToilet;
	private String hotelOther;
	private int hotelNumber;

	private Double hotelPrice;// 价格
	private String hotelImg;// 图片
	private String hotelType;// 类型

	public Double getHotelPrice() {
		return hotelPrice;
	}

	public void setHotelPrice(Double hotelPrice) {
		this.hotelPrice = hotelPrice;
	}

	public String getHotelImg() {
		return hotelImg;
	}

	public void setHotelImg(String hotelImg) {
		this.hotelImg = hotelImg;
	}

	public String getHotelType() {
		return hotelType;
	}

	public void setHotelType(String hotelType) {
		this.hotelType = hotelType;
	}

	public int getHotelId() {
		return hotelId;
	}

	public void setHotelId(int hotelId) {
		this.hotelId = hotelId;
	}

	public int getHotelPeople() {
		return hotelPeople;
	}

	public void setHotelPeople(int hotelPeople) {
		this.hotelPeople = hotelPeople;
	}

	public int getHotelWindow() {
		return hotelWindow;
	}

	public void setHotelWindow(int hotelWindow) {
		this.hotelWindow = hotelWindow;
	}

	public int getHotelBreakfas() {
		return hotelBreakfas;
	}

	public void setHotelBreakfas(int hotelBreakfas) {
		this.hotelBreakfas = hotelBreakfas;
	}

	public int getHotelToilet() {
		return hotelToilet;
	}

	public void setHotelToilet(int hotelToilet) {
		this.hotelToilet = hotelToilet;
	}

	public String getHotelOther() {
		return hotelOther;
	}

	public void setHotelOther(String hotelOther) {
		this.hotelOther = hotelOther;
	}

	public int getHotelNumber() {
		return hotelNumber;
	}

	public void setHotelNumber(int hotelNumber) {
		this.hotelNumber = hotelNumber;
	}

	@Override
	public String toString() {
		return "hotel [hotelId=" + hotelId + ", hotelPeople=" + hotelPeople
				+ ", hotelWindow=" + hotelWindow + ", hotelBreakfas="
				+ hotelBreakfas + ", hotelToilet=" + hotelToilet
				+ ", hotelOther=" + hotelOther + ", hotelNumber=" + hotelNumber
				+ "]";
	}

}
