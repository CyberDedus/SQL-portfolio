--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customerid integer NOT NULL,
    fullname character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(255) NOT NULL,
    address text
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_customerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_customerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_customerid_seq OWNER TO postgres;

--
-- Name: customer_customerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_customerid_seq OWNED BY public.customer.customerid;


--
-- Name: discount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discount (
    discountid integer NOT NULL,
    discountname character varying(255) NOT NULL,
    discountpercent numeric(5,2) NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone NOT NULL,
    CONSTRAINT discount_discountpercent_check CHECK (((discountpercent >= (0)::numeric) AND (discountpercent <= (100)::numeric)))
);


ALTER TABLE public.discount OWNER TO postgres;

--
-- Name: discount_discountid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discount_discountid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.discount_discountid_seq OWNER TO postgres;

--
-- Name: discount_discountid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discount_discountid_seq OWNED BY public.discount.discountid;


--
-- Name: loyaltyprogram; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loyaltyprogram (
    loyaltyid integer NOT NULL,
    customerid integer,
    loyaltypoints integer NOT NULL,
    enrollmentdate date NOT NULL
);


ALTER TABLE public.loyaltyprogram OWNER TO postgres;

--
-- Name: loyaltyprogram_loyaltyid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loyaltyprogram_loyaltyid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loyaltyprogram_loyaltyid_seq OWNER TO postgres;

--
-- Name: loyaltyprogram_loyaltyid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loyaltyprogram_loyaltyid_seq OWNED BY public.loyaltyprogram.loyaltyid;


--
-- Name: manager; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manager (
    managerid integer NOT NULL,
    fullname character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(255) NOT NULL
);


ALTER TABLE public.manager OWNER TO postgres;

--
-- Name: manager_managerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manager_managerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.manager_managerid_seq OWNER TO postgres;

--
-- Name: manager_managerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manager_managerid_seq OWNED BY public.manager.managerid;


--
-- Name: orderdetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderdetails (
    detailid integer NOT NULL,
    orderid integer NOT NULL,
    productid integer NOT NULL,
    quantity integer NOT NULL,
    priceatorder numeric(10,2) NOT NULL
);


ALTER TABLE public.orderdetails OWNER TO postgres;

--
-- Name: orderdetails_detailid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orderdetails_detailid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orderdetails_detailid_seq OWNER TO postgres;

--
-- Name: orderdetails_detailid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orderdetails_detailid_seq OWNED BY public.orderdetails.detailid;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    orderid integer NOT NULL,
    customerid integer NOT NULL,
    managerid integer NOT NULL,
    orderdate timestamp without time zone NOT NULL,
    deliverytype character varying(50) NOT NULL,
    deliveryaddress text,
    isdelivered boolean DEFAULT false NOT NULL,
    ispaid boolean DEFAULT false NOT NULL,
    totalcost numeric(10,2) NOT NULL,
    discountid integer
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_orderid_seq OWNER TO postgres;

--
-- Name: orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;


--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    productid integer NOT NULL,
    manufacturer character varying(255) NOT NULL,
    model character varying(255) NOT NULL,
    currentprice numeric(10,2) NOT NULL
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review (
    reviewid integer NOT NULL,
    orderid integer NOT NULL,
    customerid integer NOT NULL,
    reviewtext text,
    rating integer NOT NULL,
    CONSTRAINT review_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.review OWNER TO postgres;

--
-- Name: orderssummary; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.orderssummary AS
 SELECT orders.orderid AS "Идентификатор Заказа",
    customer.fullname AS "ФИО клиента",
    orders.orderdate AS "Дата заказа",
    product.model AS "Модель товара",
    orderdetails.quantity AS "Количество",
    orderdetails.priceatorder AS "Цена товара",
    ((orderdetails.quantity)::numeric * orderdetails.priceatorder) AS "Общая стоимость заказа",
    review.reviewtext AS "Текст отзыва",
    review.rating AS "Рейтинг отзыва"
   FROM ((((public.orders
     LEFT JOIN public.orderdetails ON ((orders.orderid = orderdetails.orderid)))
     LEFT JOIN public.product ON ((orderdetails.productid = product.productid)))
     LEFT JOIN public.review ON ((orders.orderid = review.orderid)))
     LEFT JOIN public.customer ON ((orders.customerid = customer.customerid)));


ALTER VIEW public.orderssummary OWNER TO postgres;

--
-- Name: paymentmethod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paymentmethod (
    paymentid integer NOT NULL,
    orderid integer,
    paymenttype character varying(50) NOT NULL,
    paymentcode character varying(50) NOT NULL,
    paymentdate date NOT NULL
);


ALTER TABLE public.paymentmethod OWNER TO postgres;

--
-- Name: paymentmethod_paymentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paymentmethod_paymentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paymentmethod_paymentid_seq OWNER TO postgres;

--
-- Name: paymentmethod_paymentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paymentmethod_paymentid_seq OWNED BY public.paymentmethod.paymentid;


--
-- Name: product_productid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_productid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_productid_seq OWNER TO postgres;

--
-- Name: product_productid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_productid_seq OWNED BY public.product.productid;


--
-- Name: productprice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productprice (
    priceid integer NOT NULL,
    productid integer NOT NULL,
    price numeric(10,2) NOT NULL,
    changedate timestamp without time zone NOT NULL
);


ALTER TABLE public.productprice OWNER TO postgres;

--
-- Name: productprice_priceid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productprice_priceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productprice_priceid_seq OWNER TO postgres;

--
-- Name: productprice_priceid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productprice_priceid_seq OWNED BY public.productprice.priceid;


--
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    promotionid integer NOT NULL,
    productid integer NOT NULL,
    promotionname character varying(100) NOT NULL,
    discountpercent numeric(5,2) NOT NULL,
    startdate date NOT NULL,
    enddate date NOT NULL
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- Name: promotion_promotionid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promotion_promotionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotion_promotionid_seq OWNER TO postgres;

--
-- Name: promotion_promotionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotion_promotionid_seq OWNED BY public.promotion.promotionid;


--
-- Name: purchase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase (
    purchaseid integer NOT NULL,
    supplierid integer NOT NULL,
    purchasedate timestamp without time zone NOT NULL,
    totalcost numeric(10,2) NOT NULL
);


ALTER TABLE public.purchase OWNER TO postgres;

--
-- Name: purchase_purchaseid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_purchaseid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_purchaseid_seq OWNER TO postgres;

--
-- Name: purchase_purchaseid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_purchaseid_seq OWNED BY public.purchase.purchaseid;


--
-- Name: purchasedetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchasedetails (
    detailid integer NOT NULL,
    purchaseid integer NOT NULL,
    productid integer NOT NULL,
    quantity integer NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.purchasedetails OWNER TO postgres;

--
-- Name: purchasedetails_detailid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchasedetails_detailid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchasedetails_detailid_seq OWNER TO postgres;

--
-- Name: purchasedetails_detailid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchasedetails_detailid_seq OWNED BY public.purchasedetails.detailid;


--
-- Name: returnrequests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.returnrequests (
    returnid integer NOT NULL,
    orderid integer NOT NULL,
    productid integer NOT NULL,
    reason text NOT NULL,
    status character varying(50) NOT NULL,
    requestdate date NOT NULL
);


ALTER TABLE public.returnrequests OWNER TO postgres;

--
-- Name: returnrequests_returnid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.returnrequests_returnid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.returnrequests_returnid_seq OWNER TO postgres;

--
-- Name: returnrequests_returnid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.returnrequests_returnid_seq OWNED BY public.returnrequests.returnid;


--
-- Name: review_reviewid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_reviewid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_reviewid_seq OWNER TO postgres;

--
-- Name: review_reviewid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_reviewid_seq OWNED BY public.review.reviewid;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    supplierid integer NOT NULL,
    suppliername character varying(255) NOT NULL,
    contactinfo text
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- Name: supplier_supplierid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplier_supplierid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supplier_supplierid_seq OWNER TO postgres;

--
-- Name: supplier_supplierid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplier_supplierid_seq OWNED BY public.supplier.supplierid;


--
-- Name: customer customerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer ALTER COLUMN customerid SET DEFAULT nextval('public.customer_customerid_seq'::regclass);


--
-- Name: discount discountid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount ALTER COLUMN discountid SET DEFAULT nextval('public.discount_discountid_seq'::regclass);


--
-- Name: loyaltyprogram loyaltyid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loyaltyprogram ALTER COLUMN loyaltyid SET DEFAULT nextval('public.loyaltyprogram_loyaltyid_seq'::regclass);


--
-- Name: manager managerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager ALTER COLUMN managerid SET DEFAULT nextval('public.manager_managerid_seq'::regclass);


--
-- Name: orderdetails detailid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails ALTER COLUMN detailid SET DEFAULT nextval('public.orderdetails_detailid_seq'::regclass);


--
-- Name: orders orderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);


--
-- Name: paymentmethod paymentid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paymentmethod ALTER COLUMN paymentid SET DEFAULT nextval('public.paymentmethod_paymentid_seq'::regclass);


--
-- Name: product productid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN productid SET DEFAULT nextval('public.product_productid_seq'::regclass);


--
-- Name: productprice priceid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productprice ALTER COLUMN priceid SET DEFAULT nextval('public.productprice_priceid_seq'::regclass);


--
-- Name: promotion promotionid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion ALTER COLUMN promotionid SET DEFAULT nextval('public.promotion_promotionid_seq'::regclass);


--
-- Name: purchase purchaseid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase ALTER COLUMN purchaseid SET DEFAULT nextval('public.purchase_purchaseid_seq'::regclass);


--
-- Name: purchasedetails detailid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchasedetails ALTER COLUMN detailid SET DEFAULT nextval('public.purchasedetails_detailid_seq'::regclass);


--
-- Name: returnrequests returnid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returnrequests ALTER COLUMN returnid SET DEFAULT nextval('public.returnrequests_returnid_seq'::regclass);


--
-- Name: review reviewid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review ALTER COLUMN reviewid SET DEFAULT nextval('public.review_reviewid_seq'::regclass);


--
-- Name: supplier supplierid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier ALTER COLUMN supplierid SET DEFAULT nextval('public.supplier_supplierid_seq'::regclass);


--
-- Name: customer customer_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_email_key UNIQUE (email);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customerid);


--
-- Name: discount discount_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discount
    ADD CONSTRAINT discount_pkey PRIMARY KEY (discountid);


--
-- Name: loyaltyprogram loyaltyprogram_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loyaltyprogram
    ADD CONSTRAINT loyaltyprogram_pkey PRIMARY KEY (loyaltyid);


--
-- Name: manager manager_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager
    ADD CONSTRAINT manager_email_key UNIQUE (email);


--
-- Name: manager manager_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager
    ADD CONSTRAINT manager_pkey PRIMARY KEY (managerid);


--
-- Name: orderdetails orderdetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT orderdetails_pkey PRIMARY KEY (detailid);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- Name: paymentmethod paymentmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paymentmethod
    ADD CONSTRAINT paymentmethod_pkey PRIMARY KEY (paymentid);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (productid);


--
-- Name: productprice productprice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productprice
    ADD CONSTRAINT productprice_pkey PRIMARY KEY (priceid);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (promotionid);


--
-- Name: purchase purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (purchaseid);


--
-- Name: purchasedetails purchasedetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchasedetails
    ADD CONSTRAINT purchasedetails_pkey PRIMARY KEY (detailid);


--
-- Name: returnrequests returnrequests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returnrequests
    ADD CONSTRAINT returnrequests_pkey PRIMARY KEY (returnid);


--
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (reviewid);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (supplierid);


--
-- Name: loyaltyprogram loyaltyprogram_customerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loyaltyprogram
    ADD CONSTRAINT loyaltyprogram_customerid_fkey FOREIGN KEY (customerid) REFERENCES public.customer(customerid) ON DELETE SET NULL;


--
-- Name: orderdetails orderdetails_orderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT orderdetails_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orders(orderid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orderdetails orderdetails_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT orderdetails_productid_fkey FOREIGN KEY (productid) REFERENCES public.product(productid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders orders_customerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customerid_fkey FOREIGN KEY (customerid) REFERENCES public.customer(customerid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders orders_discountid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_discountid_fkey FOREIGN KEY (discountid) REFERENCES public.discount(discountid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: orders orders_managerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_managerid_fkey FOREIGN KEY (managerid) REFERENCES public.manager(managerid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: paymentmethod paymentmethod_orderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paymentmethod
    ADD CONSTRAINT paymentmethod_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orders(orderid) ON DELETE SET NULL;


--
-- Name: productprice productprice_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productprice
    ADD CONSTRAINT productprice_productid_fkey FOREIGN KEY (productid) REFERENCES public.product(productid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion promotion_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_productid_fkey FOREIGN KEY (productid) REFERENCES public.product(productid) ON DELETE CASCADE;


--
-- Name: purchase purchase_supplierid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES public.supplier(supplierid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: purchasedetails purchasedetails_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchasedetails
    ADD CONSTRAINT purchasedetails_productid_fkey FOREIGN KEY (productid) REFERENCES public.product(productid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: purchasedetails purchasedetails_purchaseid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchasedetails
    ADD CONSTRAINT purchasedetails_purchaseid_fkey FOREIGN KEY (purchaseid) REFERENCES public.purchase(purchaseid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: returnrequests returnrequests_orderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returnrequests
    ADD CONSTRAINT returnrequests_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orders(orderid) ON DELETE CASCADE;


--
-- Name: returnrequests returnrequests_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.returnrequests
    ADD CONSTRAINT returnrequests_productid_fkey FOREIGN KEY (productid) REFERENCES public.product(productid) ON DELETE CASCADE;


--
-- Name: review review_customerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_customerid_fkey FOREIGN KEY (customerid) REFERENCES public.customer(customerid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: review review_orderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orders(orderid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

