package sg.edu.ntu.wkw.msc.is.ip._2014.googlemap3.bean;

import java.math.BigDecimal;
import lombok.Data;

@Data
public class Restaurant {

  private String name;
  private String description;
  private String streetNumber;
  private String establishment;
  private String route;
  private String sublocality;
  private String locality;
  private String administrative_area_level_2;
  private String country;
  private String postal_code;
  private String formattedAddress;
  private String lat;
  private String lng;
  private String url;
  private int avgRank;
  private BigDecimal avgPrice;

}
