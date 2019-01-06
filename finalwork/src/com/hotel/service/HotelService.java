package com.hotel.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hotel.dao.HotelDao;
import com.hotel.page.Hotel;
import com.hotel.page.Reservation;

@Service
public class HotelService {

	@Autowired
	private HotelDao hotelDao;

	public List<Hotel> getHotel(Hotel hotel) {
		// 查询用户
		List<Hotel> hotelLisy = hotelDao.getHotel(hotel);
		return hotelLisy;

	}

	/**
	 * 添加酒店预定信息
	 * 
	 * @param reservation
	 * @return
	 */
	public int addReservation(Reservation reservation) {
		/*
		 * 酒店数量减1
		 */
		Hotel hotel = new Hotel();
		hotel.setHotelNumber(reservation.getHotelNum() - 1);
		hotel.setHotelId(reservation.getHotelId());
		int num = hotelDao.updataHotelNum(hotel);
		if (num == 0) {
			return num;
		}
		/*
		 * 添加预定信息
		 */
		return hotelDao.addReservation(reservation);

	}

	/**
	 * 查询预定
	 * 
	 * @param reservation
	 * @return
	 */
	public List<Reservation> getReservation(Reservation reservation) {

		// 查询用户的预定
		List<Reservation> reservationLisy = hotelDao
				.getReservation(reservation);
		return reservationLisy;

	}

	/**
	 * 用户取消预定
	 * 
	 * @param reservation
	 * @return
	 */
	public int cancelReservation(Reservation reservation) {
		int data = 0;
		/*
		 * 先查询数据库的数据 是否是“提交”状态，只有“提交”状态的预定信息才可能被取消
		 */
		List<Reservation> reservationList = hotelDao
				.getReservation(reservation);
		String reservationStatic = reservationList.get(0)
				.getReservationStatic();

		if ("提交".equals(reservationStatic)) {
			/*
			 * 取消
			 */
			reservation.setReservationStatic("已取消");
			int num = hotelDao.cancelReservation(reservation);
			if (num == 1) {
				/*
				 * 取消成功的话，则房间数+1
				 */

				Hotel hotel = new Hotel();
				hotel.setHotelId(reservation.getHotelId());
				/*
				 * 查询原本房间数量
				 */
				List<Hotel> hotelList = hotelDao.getHotel(hotel);
				int hotelNum = hotelList.get(0).getHotelNumber();
				/*
				 * 数量加1
				 */
				hotel.setHotelNumber(hotelNum + 1);
				data = hotelDao.updataHotelNum(hotel);
			}
		}

		// 查询用户的预定

		return data;

	}

	/**
	 * 用户取消预定
	 * 
	 * @param reservation
	 * @return
	 */
	public int confirmReservation(Reservation reservation) {
		int data = 0;
		/*
		 * 先查询数据库的数据 是否是“提交”状态，只有“提交”状态的预定信息才可能被取消
		 */
		List<Reservation> reservationList = hotelDao
				.getReservation(reservation);
		String reservationStatic = reservationList.get(0)
				.getReservationStatic();

		if ("提交".equals(reservationStatic)) {
			/*
			 * 取消
			 */
			reservation.setReservationStatic("已确认");
			data = hotelDao.cancelReservation(reservation);

		}

		// 查询用户的预定

		return data;

	}
}
