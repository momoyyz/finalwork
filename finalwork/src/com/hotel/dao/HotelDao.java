package com.hotel.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.hotel.page.Hotel;
import com.hotel.page.Reservation;

@Repository
public interface HotelDao {

	/**
	 * 查询酒店
	 * 
	 * @param user
	 * @return
	 */
	public List<Hotel> getHotel(Hotel hotel);

	/**
	 * 添加预定信息
	 * 
	 * @param reservation
	 * @return
	 */
	public int addReservation(Reservation reservation);

	/**
	 * 修改酒店剩余数量
	 * 
	 * @param hotel
	 * @return
	 */
	public int updataHotelNum(Hotel hotel);

	/**
	 * 用户查询自己的预定信息
	 * 
	 * @param reservation
	 * @return
	 */
	public List<Reservation> getReservation(Reservation reservation);

	/**
	 * 用户取消预定
	 * 
	 * @param reservation
	 * @return
	 */
	public int cancelReservation(Reservation reservation);

}
