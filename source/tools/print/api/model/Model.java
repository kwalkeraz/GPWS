//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vIBM 2.2.3-11/28/2011 06:21 AM(foreman)- 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2014.04.02 at 01:44:50 PM MST 
//


package tools.print.api.model;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for model complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="model">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Name" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="Strategic" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="ConfidentialPrint" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="Color" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="NumLangDis" type="{http://www.w3.org/2001/XMLSchema}integer"/>
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
@XmlType(name = "model", propOrder = {
    "name",
    "strategic",
    "confidentialPrint",
    "color",
    "numLangDisplay",
})
public class Model {

    @XmlElement(name = "Name", required = true)
    protected String name;
    @XmlElement(name = "Strategic", required = true)
    protected String strategic;
    @XmlElement(name = "ConfidentialPrint", required = true)
    protected String confidentialPrint;
    @XmlElement(name = "Color", required = false)
    protected String color;
    @XmlElement(name = "NumLangDisplay")
    protected Integer numLangDisplay;
    @XmlAttribute(name = "id")
    protected Integer id;
    

    /**
     * Gets the value of the name property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the value of the name property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setName(String value) {
        this.name = value;
    }

    /**
     * Gets the value of the strategic property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStrategic() {
        return strategic;
    }

    /**
     * Sets the value of the strategic property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStrategic(String value) {
        this.strategic = value;
    }

    /**
     * Gets the value of the confidentialPrint property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getConfidentialPrint() {
        return confidentialPrint;
    }

    /**
     * Sets the value of the confidentialPrint property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setConfidentialPrint(String value) {
        this.confidentialPrint = value;
    }
    
    /**
     * Gets the value of the color property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getColor() {
        return color;
    }
    
    /**
     * Sets the value of the color property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setColor(String value) {
        this.color = value;
    }
    
    /**
     * Gets the value of the numLangDisplay property.
     * 
     * @return
     *     possible object is
     *     {@link Integer }
     *     
     */
    public Integer getNumLangDis() {
        return numLangDisplay;
    }

    /**
     * Sets the value of the numLangDisplay property.
     * 
     * @param value
     *     allowed object is
     *     {@link Integer }
     *     
     */
    public void setNumLangDis(Integer value) {
        this.numLangDisplay = value;
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