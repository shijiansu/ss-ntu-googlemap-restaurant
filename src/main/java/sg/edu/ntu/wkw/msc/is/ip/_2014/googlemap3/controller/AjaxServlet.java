package sg.edu.ntu.wkw.msc.is.ip._2014.googlemap3.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sg.edu.ntu.wkw.msc.is.ip._2014.googlemap3.bean.Restaurant;

import com.fasterxml.jackson.databind.ObjectMapper;

public class AjaxServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	List<Restaurant> restaurants;

	public AjaxServlet() {
		super();
		restaurants = new ArrayList<>();
		Restaurant restaurant1 = new Restaurant();
		restaurant1.setName("Jade Of India Restaurant");
		restaurant1
				.setDescription("People talk about: indian chinesefish headdining experience.");
		restaurant1
				.setFormattedAddress("172 Race Course Road, Singapore 218605");
		restaurant1.setAdministrative_area_level_2("Singapore");
		restaurant1.setCountry("Singapore");
		restaurant1.setPostal_code("218605");
		restaurant1.setRoute("Race Course Rd");
		restaurant1.setStreetNumber("172");
		restaurant1.setLat("1.310856");
		restaurant1.setLng("103.852698");
		restaurant1.setUrl("http://jadeofindia.com");

		Restaurant restaurant2 = new Restaurant();
		restaurant2.setName("Gayatri Restaurant");
		restaurant2
				.setDescription("People talk about: curry fishsouth indian cuisinefish head.");
		restaurant2
				.setFormattedAddress("122 Race Course Road, Singapore 218583");
		restaurant2.setAdministrative_area_level_2("Singapore");
		restaurant2.setCountry("Singapore");
		restaurant2.setPostal_code("218583");
		restaurant2.setRoute("Race Course Rd");
		restaurant2.setStreetNumber("122");
		restaurant2.setLat("1.309726");
		restaurant2.setLng("103.851933");
		restaurant2.setUrl("http://gayatrirestaurant.com");

		Restaurant restaurant3 = new Restaurant();
		restaurant3.setName("Delhi Restaurant");
		restaurant3
				.setDescription("People talk about: chicken tandoorinorth indianpaneer");
		restaurant3.setFormattedAddress("195 Serangoon Road, Singapore 218067");
		restaurant3.setAdministrative_area_level_2("Singapore");
		restaurant3.setCountry("Singapore");
		restaurant3.setPostal_code("218067");
		restaurant3.setRoute("Serangoon Rd");
		restaurant3.setStreetNumber("");
		restaurant3.setLat("1.309049");
		restaurant3.setLng("103.853325");
		restaurant3.setUrl("http://delhi.com.sg");

		restaurants.add(restaurant1);
		restaurants.add(restaurant2);
		restaurants.add(restaurant3);

	}

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
	}

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		Object result = new ArrayList<Object>();
		if ("search".equalsIgnoreCase(action)) {
			String restaurantName = request.getParameter("restaurantName");

			List<Restaurant> restaurantsResult = new ArrayList<Restaurant>();
			for (Restaurant restaurant : restaurants) {
				if (restaurant.getName().contains(restaurantName)) {
					restaurantsResult.add(restaurant);
				}
			}
			result = restaurantsResult;
		} else if ("changeRest".equalsIgnoreCase(action)) {
			String location = request.getParameter("location");

			String lat = location.split("-")[0];
			String lng = location.split("-")[1];

			List<Restaurant> restaurantsResult = new ArrayList<Restaurant>();
			for (Restaurant restaurant : restaurants) {
				if (restaurant.getLat().equalsIgnoreCase(lat)
						&& restaurant.getLng().equalsIgnoreCase(lng)) {
					restaurantsResult.add(restaurant);
					break;
				}
			}
			result = restaurantsResult;
		}
		response.setContentType("application/json");
		ObjectMapper objectMapper = new ObjectMapper();
		objectMapper.writeValue(response.getOutputStream(), result);
	}

}
