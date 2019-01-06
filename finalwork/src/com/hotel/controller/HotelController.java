package com.hotel.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hotel.page.Hotel;
import com.hotel.page.Reservation;
import com.hotel.service.HotelService;
import com.utils.JsonUtil;

@Controller
public class HotelController {

	@Autowired
	private HotelService hotelService;

	@RequestMapping("/getHotel.do")
	@ResponseBody
	public List<Hotel> getHotel(Hotel hotel) {
		List<Hotel> hotelLisy = hotelService.getHotel(hotel);
		return hotelLisy;
	}

	@RequestMapping("/addReservation.do")
	@ResponseBody
	public Object addReservation(Reservation reservation) {
		// num->添加记录条数
		String data = "";
		int num = hotelService.addReservation(reservation);
		try {
			data = JsonUtil.toJson(num);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return data;
	}

	@RequestMapping("/getReservation.do")
	@ResponseBody
	public List<Reservation> getReservation(Reservation reservation) {
		List<Reservation> reservationLisy = hotelService
				.getReservation(reservation);
		return reservationLisy;
	}

	@RequestMapping("/cancelReservation.do")
	@ResponseBody
	public Object cancelReservation(Reservation reservation) {
		String data = "";
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			int num = hotelService.cancelReservation(reservation);
			if (num == 1) {
				map.put("static", "success");
			} else {
				map.put("static", "error");
			}
			data = JsonUtil.toJson(map);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return data;

	}

	@RequestMapping("/confirmReservation.do")
	@ResponseBody
	public Object confirmReservation(Reservation reservation) {
		String data = "";
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			int num = hotelService.confirmReservation(reservation);
			if (num == 1) {
				map.put("static", "success");
			} else {
				map.put("static", "error");
			}
			data = JsonUtil.toJson(map);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return data;

	}
}
