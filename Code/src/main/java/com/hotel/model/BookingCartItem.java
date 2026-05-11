package com.hotel.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Đại diện một phòng trong giỏ đặt phòng tạm thời (lưu trong session).
 */
public class BookingCartItem implements Serializable {
    private int roomId;
    private String roomNumber;
    private String roomTypeName;
    private String checkIn;   // yyyy-MM-dd
    private String checkOut;  // yyyy-MM-dd
    private long nights;
    private BigDecimal pricePerNight;
    private BigDecimal subtotal;

    public BookingCartItem() {}

    public BookingCartItem(int roomId, String roomNumber, String roomTypeName,
                           String checkIn, String checkOut, long nights, BigDecimal pricePerNight) {
        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.roomTypeName = roomTypeName;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.nights = nights;
        this.pricePerNight = pricePerNight;
        this.subtotal = pricePerNight.multiply(BigDecimal.valueOf(nights));
    }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }
    public String getCheckIn() { return checkIn; }
    public void setCheckIn(String checkIn) { this.checkIn = checkIn; }
    public String getCheckOut() { return checkOut; }
    public void setCheckOut(String checkOut) { this.checkOut = checkOut; }
    public long getNights() { return nights; }
    public void setNights(long nights) { this.nights = nights; }
    public BigDecimal getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(BigDecimal pricePerNight) { this.pricePerNight = pricePerNight; }
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
}
