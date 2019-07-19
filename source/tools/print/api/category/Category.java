//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vIBM 2.2.3-11/25/2013 12:35 PM(foreman)- 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2015.03.04 at 01:51:53 PM MST 
//


package tools.print.api.category;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for category complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="category">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Category_Name" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="Description" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="Category_Code" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="Category_Value1" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="Category_Value2" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="Category_infoid" type="{http://www.w3.org/2001/XMLSchema}int"/>
 *       &lt;/sequence>
 *       &lt;attribute name="id" type="{http://www.w3.org/2001/XMLSchema}int" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "category", propOrder = {
    "categoryName",
    "description",
    "categoryCode",
    "categoryValue1",
    "categoryValue2",
    "categoryInfoid"
})
public class Category {

    @XmlElement(name = "Category_Name", required = true)
    protected String categoryName;
    @XmlElement(name = "Description", required = true)
    protected String description;
    @XmlElement(name = "Category_Code", required = true)
    protected String categoryCode;
    @XmlElement(name = "Category_Value1", required = true)
    protected String categoryValue1;
    @XmlElement(name = "Category_Value2", required = true)
    protected String categoryValue2;
    @XmlElement(name = "Category_infoid")
    protected int categoryInfoid;
    @XmlAttribute(name = "id")
    protected Integer id;

    /**
     * Gets the value of the categoryName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCategoryName() {
        return categoryName;
    }

    /**
     * Sets the value of the categoryName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCategoryName(String value) {
        this.categoryName = value;
    }

    /**
     * Gets the value of the description property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets the value of the description property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDescription(String value) {
        this.description = value;
    }

    /**
     * Gets the value of the categoryCode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCategoryCode() {
        return categoryCode;
    }

    /**
     * Sets the value of the categoryCode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCategoryCode(String value) {
        this.categoryCode = value;
    }

    /**
     * Gets the value of the categoryValue1 property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCategoryValue1() {
        return categoryValue1;
    }

    /**
     * Sets the value of the categoryValue1 property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCategoryValue1(String value) {
        this.categoryValue1 = value;
    }

    /**
     * Gets the value of the categoryValue2 property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCategoryValue2() {
        return categoryValue2;
    }

    /**
     * Sets the value of the categoryValue2 property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCategoryValue2(String value) {
        this.categoryValue2 = value;
    }

    /**
     * Gets the value of the categoryInfoid property.
     * 
     */
    public int getCategoryInfoid() {
        return categoryInfoid;
    }

    /**
     * Sets the value of the categoryInfoid property.
     * 
     */
    public void setCategoryInfoid(int value) {
        this.categoryInfoid = value;
    }

    /**
     * Gets the value of the id property.
     * 
     * @return
     *     possible object is
     *     {@link Integer }
     *     
     */
    public Integer getId() {
        return id;
    }

    /**
     * Sets the value of the id property.
     * 
     * @param value
     *     allowed object is
     *     {@link Integer }
     *     
     */
    public void setId(Integer value) {
        this.id = value;
    }

}