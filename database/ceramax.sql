--
-- PostgreSQL database dump
--

\restrict gedOJb4wel3T10GqgTz0zpJCdVDShV8ptB1vMEHcuUdpLbWSI7e3wtVtndT1Sfi

-- Dumped from database version 18.6 (6569466)
-- Dumped by pg_dump version 18.6

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: neondb_owner
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO neondb_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: neondb_owner
--

COMMENT ON SCHEMA public IS '';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: canalventaenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.canalventaenum AS ENUM (
    'online',
    'tienda_fisica'
);


ALTER TYPE public.canalventaenum OWNER TO neondb_owner;

--
-- Name: estadocarritoenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.estadocarritoenum AS ENUM (
    'activo',
    'abandonado',
    'convertido'
);


ALTER TYPE public.estadocarritoenum OWNER TO neondb_owner;

--
-- Name: estadocuponenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.estadocuponenum AS ENUM (
    'activo',
    'inactivo',
    'expirado'
);


ALTER TYPE public.estadocuponenum OWNER TO neondb_owner;

--
-- Name: estadodevolucionenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.estadodevolucionenum AS ENUM (
    'solicitada',
    'aprobada',
    'rechazada',
    'completada'
);


ALTER TYPE public.estadodevolucionenum OWNER TO neondb_owner;

--
-- Name: estadogenericoenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.estadogenericoenum AS ENUM (
    'activo',
    'inactivo'
);


ALTER TYPE public.estadogenericoenum OWNER TO neondb_owner;

--
-- Name: estadoordencompraenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.estadoordencompraenum AS ENUM (
    'pendiente',
    'aprobada',
    'recibida_parcial',
    'recibida',
    'cancelada'
);


ALTER TYPE public.estadoordencompraenum OWNER TO neondb_owner;

--
-- Name: estadopagoenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.estadopagoenum AS ENUM (
    'pendiente',
    'completado',
    'fallido',
    'reembolsado'
);


ALTER TYPE public.estadopagoenum OWNER TO neondb_owner;

--
-- Name: estadopedidoenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.estadopedidoenum AS ENUM (
    'pendiente',
    'en_transporte',
    'en_ruta',
    'en_camino',
    'listo_para_recoger',
    'entregado',
    'devuelto',
    'cancelado',
    'reembolsado'
);


ALTER TYPE public.estadopedidoenum OWNER TO neondb_owner;

--
-- Name: estadoproductoenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.estadoproductoenum AS ENUM (
    'activo',
    'inactivo',
    'descontinuado'
);


ALTER TYPE public.estadoproductoenum OWNER TO neondb_owner;

--
-- Name: estadoresenaenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.estadoresenaenum AS ENUM (
    'pendiente',
    'aprobada',
    'rechazada'
);


ALTER TYPE public.estadoresenaenum OWNER TO neondb_owner;

--
-- Name: tipoalmacenenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.tipoalmacenenum AS ENUM (
    'principal',
    'tienda_fisica',
    'tercero',
    'virtual'
);


ALTER TYPE public.tipoalmacenenum OWNER TO neondb_owner;

--
-- Name: tipodescuentoenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.tipodescuentoenum AS ENUM (
    'porcentaje',
    'monto_fijo',
    'envio_gratis'
);


ALTER TYPE public.tipodescuentoenum OWNER TO neondb_owner;

--
-- Name: tipodireccionenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.tipodireccionenum AS ENUM (
    'envio',
    'facturacion'
);


ALTER TYPE public.tipodireccionenum OWNER TO neondb_owner;

--
-- Name: tipoentregaenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.tipoentregaenum AS ENUM (
    'delivery',
    'recojo'
);


ALTER TYPE public.tipoentregaenum OWNER TO neondb_owner;

--
-- Name: tipomovimientoenum; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public.tipomovimientoenum AS ENUM (
    'entrada',
    'salida',
    'ajuste',
    'transferencia',
    'devolucion'
);


ALTER TYPE public.tipomovimientoenum OWNER TO neondb_owner;

--
-- Name: fn_actualizar_timestamp(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.fn_actualizar_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_actualizar_timestamp() OWNER TO neondb_owner;

--
-- Name: fn_detalle_pedido_reservar_stock(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.fn_detalle_pedido_reservar_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_inventario BIGINT;
    v_cantidad_antes INT;
BEGIN
    SELECT id_inventario, cantidad_disponible INTO v_id_inventario, v_cantidad_antes
    FROM inventario
    WHERE id_variante = NEW.id_variante
      AND id_almacen = NEW.id_almacen;
    UPDATE inventario
    SET cantidad_disponible = cantidad_disponible - NEW.cantidad,
        cantidad_reservada = cantidad_reservada + NEW.cantidad
    WHERE id_inventario = v_id_inventario;
    INSERT INTO movimientos_inventario (
        id_inventario, tipo_movimiento, cantidad,
        cantidad_antes, cantidad_despues,
        motivo, referencia_documento
    ) VALUES (
        v_id_inventario, 'salida', NEW.cantidad,
        v_cantidad_antes, v_cantidad_antes - NEW.cantidad,
        'Reserva de stock para pedido #' || NEW.id_pedido,
        'PED-' || NEW.id_pedido
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_detalle_pedido_reservar_stock() OWNER TO neondb_owner;

--
-- Name: fn_detalle_pedido_validar_stock(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.fn_detalle_pedido_validar_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_stock_disponible INT;
BEGIN
    SELECT cantidad_disponible INTO v_stock_disponible
    FROM inventario
    WHERE id_variante = NEW.id_variante
      AND id_almacen = NEW.id_almacen;
    IF v_stock_disponible IS NULL THEN
        RAISE EXCEPTION 'No existe registro de inventario para esta variante en el almacen %', NEW.id_almacen;
    END IF;
    IF v_stock_disponible < NEW.cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para completar la operacion (disponible: %, solicitado: %)', v_stock_disponible, NEW.cantidad;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_detalle_pedido_validar_stock() OWNER TO neondb_owner;

--
-- Name: fn_devolucion_completar_reingresar_stock(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.fn_devolucion_completar_reingresar_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_inventario BIGINT;
    v_cantidad_antes INT;
BEGIN
    IF NEW.estado = 'completada' AND OLD.estado != 'completada' THEN
        SELECT inv.id_inventario, inv.cantidad_disponible INTO v_id_inventario, v_cantidad_antes
        FROM inventario inv
        INNER JOIN detalle_pedido dp ON dp.id_variante = inv.id_variante
                                    AND dp.id_almacen = inv.id_almacen
        WHERE dp.id_detalle_pedido = NEW.id_detalle_pedido
        LIMIT 1;
        UPDATE inventario
        SET cantidad_disponible = cantidad_disponible + NEW.cantidad
        WHERE id_inventario = v_id_inventario;
        INSERT INTO movimientos_inventario (
            id_inventario, tipo_movimiento, cantidad,
            cantidad_antes, cantidad_despues,
            motivo, referencia_documento
        ) VALUES (
            v_id_inventario,
            'devolucion',
            NEW.cantidad,
            v_cantidad_antes,
            v_cantidad_antes + NEW.cantidad,
            'Devolucion completada pedido #' || NEW.id_pedido,
            'DEV-' || NEW.id_devolucion
        );
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_devolucion_completar_reingresar_stock() OWNER TO neondb_owner;

--
-- Name: fn_orden_compra_recibir_stock(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.fn_orden_compra_recibir_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_inventario BIGINT;
    v_id_almacen INT;
    v_diferencia INT;
    v_cantidad_antes INT;
BEGIN
    IF NEW.cantidad_recibida > OLD.cantidad_recibida THEN
        v_diferencia := NEW.cantidad_recibida - OLD.cantidad_recibida;
        SELECT id_almacen_destino INTO v_id_almacen
        FROM ordenes_compra
        WHERE id_orden_compra = NEW.id_orden_compra;
        SELECT id_inventario, cantidad_disponible INTO v_id_inventario, v_cantidad_antes
        FROM inventario
        WHERE id_variante = NEW.id_variante
          AND id_almacen = v_id_almacen;
        IF v_id_inventario IS NULL THEN
            INSERT INTO inventario (id_variante, id_almacen, cantidad_disponible, cantidad_reservada)
            VALUES (NEW.id_variante, v_id_almacen, v_diferencia, 0)
            RETURNING id_inventario INTO v_id_inventario;
            v_cantidad_antes := 0;
        ELSE
            UPDATE inventario
            SET cantidad_disponible = cantidad_disponible + v_diferencia
            WHERE id_inventario = v_id_inventario;
        END IF;

        INSERT INTO movimientos_inventario (
            id_inventario, tipo_movimiento, cantidad,
            cantidad_antes, cantidad_despues,
            motivo, referencia_documento
        ) VALUES (
            v_id_inventario,
            'entrada',
            v_diferencia,
            v_cantidad_antes,
            v_cantidad_antes + v_diferencia,
            'Recepcion orden de compra #' || NEW.id_orden_compra,
            'OC-' || NEW.id_orden_compra
        );

    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_orden_compra_recibir_stock() OWNER TO neondb_owner;

--
-- Name: fn_pedido_cancelar_liberar_stock(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.fn_pedido_cancelar_liberar_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.estado = 'cancelado' AND OLD.estado != 'cancelado' THEN
        INSERT INTO movimientos_inventario (
            id_inventario, tipo_movimiento, cantidad,
            cantidad_antes, cantidad_despues,
            motivo, referencia_documento
        )
        SELECT
            inv.id_inventario,
            'ajuste',
            dp.cantidad,
            inv.cantidad_disponible,
            inv.cantidad_disponible + dp.cantidad,
            'Liberacion por cancelacion pedido #' || NEW.id_pedido,
            'PED-' || NEW.id_pedido
        FROM inventario inv
        INNER JOIN detalle_pedido dp ON dp.id_variante = inv.id_variante
                                    AND dp.id_almacen = inv.id_almacen
        WHERE dp.id_pedido = NEW.id_pedido;
        UPDATE inventario inv
        SET cantidad_disponible = inv.cantidad_disponible + dp.cantidad,
            cantidad_reservada = inv.cantidad_reservada - dp.cantidad
        FROM detalle_pedido dp
        WHERE dp.id_variante = inv.id_variante
          AND dp.id_almacen = inv.id_almacen
          AND dp.id_pedido = NEW.id_pedido;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_pedido_cancelar_liberar_stock() OWNER TO neondb_owner;

--
-- Name: fn_pedido_entregado_confirmar_stock(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.fn_pedido_entregado_confirmar_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.estado = 'entregado' AND OLD.estado != 'entregado' THEN
        INSERT INTO movimientos_inventario (
            id_inventario, tipo_movimiento, cantidad,
            cantidad_antes, cantidad_despues,
            motivo, referencia_documento
        )
        SELECT
            inv.id_inventario,
            'salida',
            dp.cantidad,
            inv.cantidad_reservada,
            inv.cantidad_reservada - dp.cantidad,
            'Entrega confirmada pedido #' || NEW.id_pedido,
            'PED-' || NEW.id_pedido
        FROM inventario inv
        INNER JOIN detalle_pedido dp ON dp.id_variante = inv.id_variante
                                    AND dp.id_almacen = inv.id_almacen
        WHERE dp.id_pedido = NEW.id_pedido;
        UPDATE inventario inv
        SET cantidad_reservada = inv.cantidad_reservada - dp.cantidad
        FROM detalle_pedido dp
        WHERE dp.id_variante = inv.id_variante
          AND dp.id_almacen = inv.id_almacen
          AND dp.id_pedido = NEW.id_pedido;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_pedido_entregado_confirmar_stock() OWNER TO neondb_owner;

--
-- Name: set_fecha_actualizacion(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.set_fecha_actualizacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.fecha_actualizacion := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_fecha_actualizacion() OWNER TO neondb_owner;

--
-- Name: set_ultima_actualizacion(); Type: FUNCTION; Schema: public; Owner: neondb_owner
--

CREATE FUNCTION public.set_ultima_actualizacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.ultima_actualizacion := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_ultima_actualizacion() OWNER TO neondb_owner;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: almacenes; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.almacenes (
    id_almacen integer NOT NULL,
    nombre character varying(100) NOT NULL,
    tipo public.tipoalmacenenum DEFAULT 'principal'::public.tipoalmacenenum NOT NULL,
    direccion character varying(255),
    ciudad character varying(100),
    pais character varying(100),
    permite_recojo_cliente boolean DEFAULT false NOT NULL,
    estado public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL
);


ALTER TABLE public.almacenes OWNER TO neondb_owner;

--
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.almacenes ALTER COLUMN id_almacen ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.almacenes_id_almacen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: atributos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.atributos (
    id_atributo integer NOT NULL,
    nombre character varying(60) NOT NULL,
    estado character varying(20) NOT NULL
);


ALTER TABLE public.atributos OWNER TO neondb_owner;

--
-- Name: atributos_id_atributo_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.atributos ALTER COLUMN id_atributo ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.atributos_id_atributo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auditorias; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.auditorias (
    id_auditoria bigint NOT NULL,
    id_usuario bigint,
    accion character varying(50) NOT NULL,
    entidad character varying(100) NOT NULL,
    entidad_id bigint,
    valores_anteriores text,
    valores_nuevos text,
    descripcion character varying(255),
    ip_address character varying(50),
    user_agent character varying(500),
    fecha_auditoria timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.auditorias OWNER TO neondb_owner;

--
-- Name: auditorias_id_auditoria_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.auditorias ALTER COLUMN id_auditoria ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auditorias_id_auditoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: carritos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.carritos (
    id_carrito bigint NOT NULL,
    id_usuario bigint,
    session_id character varying(100),
    estado public.estadocarritoenum DEFAULT 'activo'::public.estadocarritoenum NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_carritos_propietario CHECK (((id_usuario IS NOT NULL) OR (session_id IS NOT NULL)))
);


ALTER TABLE public.carritos OWNER TO neondb_owner;

--
-- Name: carritos_id_carrito_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.carritos ALTER COLUMN id_carrito ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.carritos_id_carrito_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: categoria_atributos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.categoria_atributos (
    id_categoria integer NOT NULL,
    id_atributo integer NOT NULL,
    es_obligatorio boolean DEFAULT false NOT NULL
);


ALTER TABLE public.categoria_atributos OWNER TO neondb_owner;

--
-- Name: categorias; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.categorias (
    id_categoria integer NOT NULL,
    id_categoria_padre integer,
    nombre character varying(100) NOT NULL,
    slug character varying(120) NOT NULL,
    descripcion text,
    imagen_url character varying(500),
    imagen_public_id character varying(250),
    orden integer DEFAULT 0 NOT NULL,
    estado public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL,
    CONSTRAINT ck_categorias_orden CHECK ((orden >= 0))
);


ALTER TABLE public.categorias OWNER TO neondb_owner;

--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.categorias ALTER COLUMN id_categoria ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.categorias_id_categoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.clientes (
    id_cliente bigint NOT NULL,
    tipo_documento character varying(20),
    numero_documento character varying(20),
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    telefono character varying(30),
    email character varying(150),
    ruc character varying(20),
    razon_social character varying(200),
    estado public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    departamento character varying(100),
    provincia character varying(100),
    distrito character varying(100),
    direccion character varying(250),
    referencia character varying(250),
    codigo_postal character varying(20),
    password_hash character varying(255)
);


ALTER TABLE public.clientes OWNER TO neondb_owner;

--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.clientes ALTER COLUMN id_cliente ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.clientes_id_cliente_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: configuracion_tienda; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.configuracion_tienda (
    id_configuracion integer DEFAULT 1 NOT NULL,
    nombre_tienda character varying(150) NOT NULL,
    moneda character varying(10) DEFAULT 'USD'::character varying NOT NULL,
    pais_operacion character varying(100),
    porcentaje_impuesto_default numeric(5,2) DEFAULT 0,
    permite_venta_presencial boolean DEFAULT true NOT NULL,
    permite_recojo_tienda boolean DEFAULT true NOT NULL,
    CONSTRAINT ck_configuracion_id_unico CHECK ((id_configuracion = 1)),
    CONSTRAINT ck_configuracion_impuesto CHECK (((porcentaje_impuesto_default IS NULL) OR ((porcentaje_impuesto_default >= (0)::numeric) AND (porcentaje_impuesto_default <= (100)::numeric))))
);


ALTER TABLE public.configuracion_tienda OWNER TO neondb_owner;

--
-- Name: cupones; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.cupones (
    id_cupon integer NOT NULL,
    codigo character varying(50) NOT NULL,
    tipo_descuento public.tipodescuentoenum NOT NULL,
    valor numeric(10,2) NOT NULL,
    monto_minimo_compra numeric(12,2) DEFAULT 0 NOT NULL,
    fecha_inicio timestamp without time zone NOT NULL,
    fecha_fin timestamp without time zone NOT NULL,
    uso_maximo integer,
    uso_actual integer DEFAULT 0 NOT NULL,
    estado public.estadocuponenum DEFAULT 'activo'::public.estadocuponenum NOT NULL,
    CONSTRAINT ck_cupon_fechas CHECK ((fecha_fin >= fecha_inicio)),
    CONSTRAINT ck_cupon_monto_minimo CHECK ((monto_minimo_compra >= (0)::numeric)),
    CONSTRAINT ck_cupon_uso_actual CHECK ((uso_actual >= 0)),
    CONSTRAINT ck_cupon_usos CHECK (((uso_maximo IS NULL) OR ((uso_maximo >= 0) AND (uso_actual <= uso_maximo)))),
    CONSTRAINT ck_cupon_valor CHECK ((valor >= (0)::numeric))
);


ALTER TABLE public.cupones OWNER TO neondb_owner;

--
-- Name: cupones_id_cupon_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.cupones ALTER COLUMN id_cupon ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.cupones_id_cupon_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: detalle_carrito; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.detalle_carrito (
    id_detalle_carrito bigint NOT NULL,
    id_carrito bigint NOT NULL,
    id_variante bigint NOT NULL,
    cantidad integer DEFAULT 1 NOT NULL,
    precio_unitario_momento numeric(12,2) NOT NULL,
    fecha_agregado timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_detalle_carrito_cantidad CHECK ((cantidad > 0)),
    CONSTRAINT ck_detalle_carrito_precio CHECK ((precio_unitario_momento >= (0)::numeric))
);


ALTER TABLE public.detalle_carrito OWNER TO neondb_owner;

--
-- Name: detalle_carrito_id_detalle_carrito_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.detalle_carrito ALTER COLUMN id_detalle_carrito ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.detalle_carrito_id_detalle_carrito_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: detalle_orden_compra; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.detalle_orden_compra (
    id_detalle bigint NOT NULL,
    id_orden_compra bigint NOT NULL,
    id_variante bigint,
    cantidad_solicitada integer NOT NULL,
    cantidad_recibida integer DEFAULT 0 NOT NULL,
    costo_unitario numeric(12,2) NOT NULL,
    subtotal numeric(14,2) GENERATED ALWAYS AS (((cantidad_solicitada)::numeric * costo_unitario)) STORED,
    CONSTRAINT ck_detalle_orden_cantidades CHECK (((cantidad_solicitada > 0) AND (cantidad_recibida >= 0) AND (cantidad_recibida <= cantidad_solicitada))),
    CONSTRAINT ck_detalle_orden_costo CHECK ((costo_unitario >= (0)::numeric))
);


ALTER TABLE public.detalle_orden_compra OWNER TO neondb_owner;

--
-- Name: detalle_orden_compra_id_detalle_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.detalle_orden_compra ALTER COLUMN id_detalle ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.detalle_orden_compra_id_detalle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: detalle_pedido; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.detalle_pedido (
    id_detalle_pedido bigint NOT NULL,
    id_pedido bigint NOT NULL,
    id_variante bigint,
    id_almacen integer NOT NULL,
    sku_snapshot character varying(60) NOT NULL,
    nombre_producto_snapshot character varying(200) NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    subtotal numeric(14,2) GENERATED ALWAYS AS (((cantidad)::numeric * precio_unitario)) STORED,
    CONSTRAINT ck_detalle_pedido_cantidad CHECK ((cantidad > 0)),
    CONSTRAINT ck_detalle_pedido_precio CHECK ((precio_unitario >= (0)::numeric))
);


ALTER TABLE public.detalle_pedido OWNER TO neondb_owner;

--
-- Name: detalle_pedido_id_detalle_pedido_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.detalle_pedido ALTER COLUMN id_detalle_pedido ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.detalle_pedido_id_detalle_pedido_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: devoluciones; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.devoluciones (
    id_devolucion bigint NOT NULL,
    id_pedido bigint NOT NULL,
    id_detalle_pedido bigint NOT NULL,
    cantidad integer NOT NULL,
    motivo character varying(255) NOT NULL,
    estado public.estadodevolucionenum DEFAULT 'solicitada'::public.estadodevolucionenum,
    monto_reembolso numeric(12,2) DEFAULT 0 NOT NULL,
    fecha_solicitud timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_resolucion timestamp without time zone,
    CONSTRAINT ck_devoluciones_cantidad CHECK ((cantidad > 0)),
    CONSTRAINT ck_devoluciones_reembolso CHECK ((monto_reembolso >= (0)::numeric))
);


ALTER TABLE public.devoluciones OWNER TO neondb_owner;

--
-- Name: devoluciones_id_devolucion_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.devoluciones ALTER COLUMN id_devolucion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.devoluciones_id_devolucion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: direcciones; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.direcciones (
    id_direccion bigint NOT NULL,
    id_usuario bigint NOT NULL,
    tipo public.tipodireccionenum NOT NULL,
    calle character varying(200) NOT NULL,
    numero_ext character varying(20),
    colonia_sector character varying(100),
    ciudad character varying(100) NOT NULL,
    estado_provincia character varying(100) NOT NULL,
    codigo_postal character varying(20) NOT NULL,
    pais character varying(100) NOT NULL,
    telefono_contacto character varying(30),
    es_predeterminada boolean DEFAULT false NOT NULL
);


ALTER TABLE public.direcciones OWNER TO neondb_owner;

--
-- Name: direcciones_id_direccion_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.direcciones ALTER COLUMN id_direccion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.direcciones_id_direccion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: envios; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.envios (
    id_envio bigint NOT NULL,
    id_pedido bigint NOT NULL,
    id_transportista integer,
    numero_seguimiento character varying(100),
    costo_envio numeric(12,2) DEFAULT 0 NOT NULL,
    fecha_envio timestamp without time zone,
    fecha_entrega_estimada date,
    fecha_entrega_real timestamp without time zone,
    CONSTRAINT ck_envios_costo CHECK ((costo_envio >= (0)::numeric))
);


ALTER TABLE public.envios OWNER TO neondb_owner;

--
-- Name: envios_id_envio_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.envios ALTER COLUMN id_envio ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.envios_id_envio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: imagenes_categoria; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.imagenes_categoria (
    id_imagen_categoria bigint NOT NULL,
    id_categoria integer NOT NULL,
    url_imagen character varying(500) NOT NULL,
    imagen_public_id character varying(250),
    es_principal boolean DEFAULT false NOT NULL,
    orden integer DEFAULT 0 NOT NULL,
    CONSTRAINT ck_imagenes_categoria_orden CHECK ((orden >= 0))
);


ALTER TABLE public.imagenes_categoria OWNER TO neondb_owner;

--
-- Name: imagenes_categoria_id_imagen_categoria_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.imagenes_categoria ALTER COLUMN id_imagen_categoria ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.imagenes_categoria_id_imagen_categoria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: imagenes_producto; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.imagenes_producto (
    id_imagen bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_variante bigint,
    url_imagen character varying(500) NOT NULL,
    imagen_public_id character varying(250),
    es_principal boolean DEFAULT false NOT NULL,
    orden integer DEFAULT 0 NOT NULL,
    CONSTRAINT ck_imagenes_producto_orden CHECK ((orden >= 0))
);


ALTER TABLE public.imagenes_producto OWNER TO neondb_owner;

--
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.imagenes_producto ALTER COLUMN id_imagen ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.imagenes_producto_id_imagen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: inventario; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.inventario (
    id_inventario bigint NOT NULL,
    id_variante bigint NOT NULL,
    id_almacen integer NOT NULL,
    cantidad_disponible integer DEFAULT 0 NOT NULL,
    cantidad_reservada integer DEFAULT 0 NOT NULL,
    stock_minimo integer DEFAULT 0 NOT NULL,
    stock_maximo integer,
    punto_reorden integer DEFAULT 0 NOT NULL,
    permite_reposicion boolean DEFAULT true NOT NULL,
    ultima_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_inventario_cantidades CHECK (((cantidad_disponible >= 0) AND (cantidad_reservada >= 0) AND (stock_minimo >= 0) AND ((stock_maximo IS NULL) OR (stock_maximo >= 0)) AND (punto_reorden >= 0))),
    CONSTRAINT ck_inventario_stock_maximo_minimo CHECK (((stock_maximo IS NULL) OR (stock_maximo >= stock_minimo)))
);


ALTER TABLE public.inventario OWNER TO neondb_owner;

--
-- Name: inventario_id_inventario_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.inventario ALTER COLUMN id_inventario ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.inventario_id_inventario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lista_deseos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.lista_deseos (
    id_lista_deseos bigint NOT NULL,
    id_usuario bigint NOT NULL,
    id_variante bigint NOT NULL,
    fecha_agregado timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.lista_deseos OWNER TO neondb_owner;

--
-- Name: lista_deseos_id_lista_deseos_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.lista_deseos ALTER COLUMN id_lista_deseos ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.lista_deseos_id_lista_deseos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: marcas; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.marcas (
    id_marca integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    logo_url character varying(500),
    sitio_web character varying(255),
    estado public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL
);


ALTER TABLE public.marcas OWNER TO neondb_owner;

--
-- Name: marcas_id_marca_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.marcas ALTER COLUMN id_marca ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.marcas_id_marca_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: metodos_pago; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.metodos_pago (
    id_metodo_pago integer NOT NULL,
    nombre character varying(60) NOT NULL,
    estado public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL
);


ALTER TABLE public.metodos_pago OWNER TO neondb_owner;

--
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.metodos_pago ALTER COLUMN id_metodo_pago ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.metodos_pago_id_metodo_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: movimientos_inventario; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.movimientos_inventario (
    id_movimiento bigint NOT NULL,
    id_inventario bigint NOT NULL,
    tipo_movimiento public.tipomovimientoenum NOT NULL,
    cantidad integer NOT NULL,
    cantidad_antes integer NOT NULL,
    cantidad_despues integer NOT NULL,
    motivo character varying(255),
    referencia_documento character varying(100),
    id_usuario_responsable bigint,
    fecha_movimiento timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_movimientos_cantidad CHECK ((cantidad > 0)),
    CONSTRAINT ck_movimientos_saldos CHECK (((cantidad_antes >= 0) AND (cantidad_despues >= 0)))
);


ALTER TABLE public.movimientos_inventario OWNER TO neondb_owner;

--
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.movimientos_inventario ALTER COLUMN id_movimiento ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.movimientos_inventario_id_movimiento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notificaciones; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.notificaciones (
    id_notificacion bigint NOT NULL,
    id_usuario_destino bigint,
    titulo character varying(100) NOT NULL,
    mensaje text,
    tipo character varying(50),
    entidad_referencia character varying(100),
    entidad_id bigint,
    leida boolean DEFAULT false NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notificaciones OWNER TO neondb_owner;

--
-- Name: notificaciones_id_notificacion_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.notificaciones ALTER COLUMN id_notificacion ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.notificaciones_id_notificacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ordenes_compra; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.ordenes_compra (
    id_orden_compra bigint NOT NULL,
    id_proveedor integer NOT NULL,
    id_almacen_destino integer NOT NULL,
    fecha_orden timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_recepcion_estimada date,
    estado public.estadoordencompraenum DEFAULT 'pendiente'::public.estadoordencompraenum NOT NULL,
    total numeric(14,2) DEFAULT 0 NOT NULL,
    id_usuario_creador bigint,
    CONSTRAINT ck_ordenes_compra_total CHECK ((total >= (0)::numeric))
);


ALTER TABLE public.ordenes_compra OWNER TO neondb_owner;

--
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.ordenes_compra ALTER COLUMN id_orden_compra ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ordenes_compra_id_orden_compra_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pagos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.pagos (
    id_pago bigint NOT NULL,
    id_pedido bigint NOT NULL,
    id_metodo_pago integer NOT NULL,
    monto numeric(14,2) NOT NULL,
    estado_pago public.estadopagoenum DEFAULT 'pendiente'::public.estadopagoenum,
    referencia_transaccion character varying(150),
    pasarela_pago character varying(60),
    fecha_pago timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_pagos_monto CHECK ((monto >= (0)::numeric))
);


ALTER TABLE public.pagos OWNER TO neondb_owner;

--
-- Name: pagos_id_pago_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.pagos ALTER COLUMN id_pago ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.pagos_id_pago_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pedidos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.pedidos (
    id_pedido bigint NOT NULL,
    numero_pedido character varying(30) NOT NULL,
    id_usuario bigint,
    id_vendedor bigint,
    canal_venta public.canalventaenum NOT NULL,
    tipo_entrega public.tipoentregaenum NOT NULL,
    nombre_cliente_invitado character varying(200),
    telefono_cliente_invitado character varying(30),
    documento_cliente_invitado character varying(30),
    id_cupon integer,
    subtotal numeric(14,2) NOT NULL,
    descuento numeric(14,2) DEFAULT 0 NOT NULL,
    costo_envio numeric(12,2) DEFAULT 0 NOT NULL,
    impuestos numeric(12,2) DEFAULT 0 NOT NULL,
    total numeric(14,2) NOT NULL,
    estado public.estadopedidoenum DEFAULT 'pendiente'::public.estadopedidoenum NOT NULL,
    notas text,
    fecha_pedido timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tipo_comprobante character varying(20) DEFAULT 'BOLETA'::character varying NOT NULL,
    ruc_cliente character varying(20),
    razon_social_cliente character varying(200),
    email_cliente_invitado character varying(150),
    nombre_receptor character varying(200),
    documento_receptor character varying(30),
    direccion_envio_texto character varying(500),
    id_sucursal_recojo integer,
    id_cliente bigint,
    tipo_documento_cliente_snapshot character varying(20),
    direccion_cliente_snapshot character varying(500),
    departamento_cliente_snapshot character varying(100),
    provincia_cliente_snapshot character varying(100),
    distrito_cliente_snapshot character varying(100),
    referencia_cliente_snapshot character varying(250),
    codigo_postal_cliente_snapshot character varying(20),
    ciudad_cliente_snapshot character varying(100),
    pais_cliente_snapshot character varying(100),
    CONSTRAINT ck_pedidos_delivery_direccion CHECK (((tipo_entrega <> 'delivery'::public.tipoentregaenum) OR (direccion_envio_texto IS NOT NULL))),
    CONSTRAINT ck_pedidos_factura_datos CHECK ((((tipo_comprobante)::text <> 'FACTURA'::text) OR ((ruc_cliente IS NOT NULL) AND (length(TRIM(BOTH FROM ruc_cliente)) = 11) AND (razon_social_cliente IS NOT NULL) AND (length(TRIM(BOTH FROM razon_social_cliente)) > 0)))),
    CONSTRAINT ck_pedidos_importes CHECK (((subtotal >= (0)::numeric) AND (descuento >= (0)::numeric) AND (costo_envio >= (0)::numeric) AND (impuestos >= (0)::numeric) AND (total >= (0)::numeric))),
    CONSTRAINT ck_pedidos_recojo_sucursal CHECK (((tipo_entrega <> 'recojo'::public.tipoentregaenum) OR (id_sucursal_recojo IS NOT NULL))),
    CONSTRAINT ck_pedidos_tipo_comprobante CHECK (((tipo_comprobante)::text = ANY ((ARRAY['BOLETA'::character varying, 'FACTURA'::character varying])::text[])))
);


ALTER TABLE public.pedidos OWNER TO neondb_owner;

--
-- Name: pedidos_id_pedido_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.pedidos ALTER COLUMN id_pedido ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.pedidos_id_pedido_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: permisos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.permisos (
    id_permiso integer NOT NULL,
    nombre_permiso character varying(80) NOT NULL,
    descripcion character varying(255),
    activo public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL
);


ALTER TABLE public.permisos OWNER TO neondb_owner;

--
-- Name: permisos_id_permiso_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.permisos ALTER COLUMN id_permiso ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.permisos_id_permiso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: productos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.productos (
    id_producto bigint NOT NULL,
    sku character varying(50) NOT NULL,
    id_categoria integer NOT NULL,
    id_marca integer,
    id_proveedor integer,
    nombre character varying(200) NOT NULL,
    descripcion_corta character varying(500),
    descripcion text,
    precio_base numeric(12,2) NOT NULL,
    costo numeric(12,2) DEFAULT 0 NOT NULL,
    descuento_porcentaje numeric(5,2) DEFAULT 0 NOT NULL,
    especificaciones jsonb DEFAULT '{}'::jsonb NOT NULL,
    destacado boolean DEFAULT false NOT NULL,
    tiene_descuento boolean DEFAULT false NOT NULL,
    fecha_caducidad date,
    requiere_envio_fisico boolean DEFAULT true NOT NULL,
    estado public.estadoproductoenum DEFAULT 'activo'::public.estadoproductoenum NOT NULL,
    meta_titulo character varying(200),
    meta_descripcion character varying(300),
    creado_por bigint,
    actualizado_por bigint,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ck_productos_costo CHECK ((costo >= (0)::numeric)),
    CONSTRAINT ck_productos_descuento CHECK (((descuento_porcentaje >= (0)::numeric) AND (descuento_porcentaje <= (100)::numeric))),
    CONSTRAINT ck_productos_precio_base CHECK ((precio_base >= (0)::numeric))
);


ALTER TABLE public.productos OWNER TO neondb_owner;

--
-- Name: productos_id_producto_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.productos ALTER COLUMN id_producto ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.productos_id_producto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: proveedores; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.proveedores (
    id_proveedor integer NOT NULL,
    nombre_empresa character varying(150) NOT NULL,
    contacto_nombre character varying(100),
    email character varying(150),
    telefono character varying(30),
    direccion character varying(255),
    condiciones_pago character varying(100),
    estado public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL
);


ALTER TABLE public.proveedores OWNER TO neondb_owner;

--
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.proveedores ALTER COLUMN id_proveedor ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.proveedores_id_proveedor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: resenas; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.resenas (
    id_resena bigint NOT NULL,
    id_producto bigint NOT NULL,
    id_usuario bigint NOT NULL,
    id_pedido bigint,
    calificacion smallint NOT NULL,
    titulo character varying(150),
    comentario text,
    estado public.estadoresenaenum DEFAULT 'pendiente'::public.estadoresenaenum,
    fecha_resena timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_resenas_calificacion CHECK (((calificacion >= 1) AND (calificacion <= 5)))
);


ALTER TABLE public.resenas OWNER TO neondb_owner;

--
-- Name: resenas_id_resena_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.resenas ALTER COLUMN id_resena ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.resenas_id_resena_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rol_permisos; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.rol_permisos (
    id_rol integer NOT NULL,
    id_permiso integer NOT NULL,
    activo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.rol_permisos OWNER TO neondb_owner;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.roles (
    id_rol integer NOT NULL,
    nombre_rol character varying(50) NOT NULL,
    descripcion character varying(255),
    activo public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL
);


ALTER TABLE public.roles OWNER TO neondb_owner;

--
-- Name: roles_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.roles ALTER COLUMN id_rol ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.roles_id_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sucursales; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.sucursales (
    id_sucursal integer NOT NULL,
    nombre character varying(150) NOT NULL,
    direccion character varying(255),
    distrito character varying(100),
    departamento character varying(100),
    referencia character varying(255),
    codigo_postal character varying(20),
    telefono character varying(30),
    email character varying(150),
    horario_atencion character varying(200),
    latitud numeric(10,7),
    longitud numeric(10,7),
    permite_recojo boolean DEFAULT true NOT NULL,
    permite_delivery boolean DEFAULT true NOT NULL,
    estado public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL,
    CONSTRAINT ck_sucursales_latitud CHECK (((latitud IS NULL) OR ((latitud >= ('-90'::integer)::numeric) AND (latitud <= (90)::numeric)))),
    CONSTRAINT ck_sucursales_longitud CHECK (((longitud IS NULL) OR ((longitud >= ('-180'::integer)::numeric) AND (longitud <= (180)::numeric))))
);


ALTER TABLE public.sucursales OWNER TO neondb_owner;

--
-- Name: sucursales_id_sucursal_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.sucursales ALTER COLUMN id_sucursal ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.sucursales_id_sucursal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tokens_invalidados; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.tokens_invalidados (
    id_token_invalidado bigint NOT NULL,
    token_hash character varying(64) NOT NULL,
    fecha_expiracion timestamp without time zone NOT NULL,
    fecha_invalidacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tokens_invalidados OWNER TO neondb_owner;

--
-- Name: tokens_invalidados_id_token_invalidado_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.tokens_invalidados ALTER COLUMN id_token_invalidado ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tokens_invalidados_id_token_invalidado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: transportistas; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.transportistas (
    id_transportista integer NOT NULL,
    nombre character varying(100) NOT NULL,
    sitio_rastreo_url character varying(255),
    estado public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL
);


ALTER TABLE public.transportistas OWNER TO neondb_owner;

--
-- Name: transportistas_id_transportista_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.transportistas ALTER COLUMN id_transportista ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.transportistas_id_transportista_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.usuarios (
    id_usuario bigint NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password_hash character varying(255) NOT NULL,
    tipo_documento character varying(20),
    numero_documento character varying(20),
    telefono character varying(30),
    fecha_nacimiento date,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_eliminacion timestamp without time zone,
    rol character varying(20) DEFAULT 'CLIENTE'::character varying NOT NULL,
    imagen_url character varying(20),
    estado character varying(20) DEFAULT 'activo'::character varying NOT NULL,
    intentos_login_fallidos integer DEFAULT 0 NOT NULL,
    CONSTRAINT ck_usuarios_estado CHECK (((estado)::text = ANY ((ARRAY['activo'::character varying, 'inactivo'::character varying, 'bloqueado'::character varying])::text[]))),
    CONSTRAINT ck_usuarios_intentos_login CHECK ((intentos_login_fallidos >= 0)),
    CONSTRAINT ck_usuarios_rol CHECK (((rol)::text = ANY ((ARRAY['ADMIN'::character varying, 'VENDEDOR'::character varying, 'LOGISTICA'::character varying, 'CLIENTE'::character varying])::text[])))
);


ALTER TABLE public.usuarios OWNER TO neondb_owner;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.usuarios ALTER COLUMN id_usuario ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.usuarios_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: valores_atributo; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.valores_atributo (
    id_valor integer NOT NULL,
    id_atributo integer NOT NULL,
    valor character varying(100) NOT NULL
);


ALTER TABLE public.valores_atributo OWNER TO neondb_owner;

--
-- Name: valores_atributo_id_valor_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.valores_atributo ALTER COLUMN id_valor ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.valores_atributo_id_valor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: variante_atributo_valor; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.variante_atributo_valor (
    id_variante bigint NOT NULL,
    id_valor integer NOT NULL
);


ALTER TABLE public.variante_atributo_valor OWNER TO neondb_owner;

--
-- Name: variantes_producto; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.variantes_producto (
    id_variante bigint NOT NULL,
    id_producto bigint NOT NULL,
    sku_variante character varying(60) NOT NULL,
    codigo_barras character varying(60),
    precio_adicional numeric(12,2) DEFAULT 0 NOT NULL,
    estado public.estadogenericoenum DEFAULT 'activo'::public.estadogenericoenum NOT NULL,
    CONSTRAINT ck_variantes_precio_adicional CHECK ((precio_adicional >= (0)::numeric))
);


ALTER TABLE public.variantes_producto OWNER TO neondb_owner;

--
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

ALTER TABLE public.variantes_producto ALTER COLUMN id_variante ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.variantes_producto_id_variante_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: almacenes; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.almacenes (id_almacen, nombre, tipo, direccion, ciudad, pais, permite_recojo_cliente, estado) FROM stdin;
5	Almacen Central Lima	principal	Av. Argentina 2450	Lima	Peru	t	activo
\.


--
-- Data for Name: atributos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.atributos (id_atributo, nombre, estado) FROM stdin;
3	Color	activo
6	Días festivos	activo
7	Forma	activo
12	Tamaño	activo
\.


--
-- Data for Name: auditorias; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.auditorias (id_auditoria, id_usuario, accion, entidad, entidad_id, valores_anteriores, valores_nuevos, descripcion, ip_address, user_agent, fecha_auditoria) FROM stdin;
204	1	CREAR	Notificacion	16	[{"id":1,"nombre":"Administrador","apellido":"CeraMax","email":"admin@ceramax.com","passwordHash":"$2a$10$LhgGim88M7ZLtpMUq21YT.7BIR/NlZ4MprriNLOscigQrOwnYF86i","tipoDocumento":null,"numeroDocumento":null,"telefono":null,"fechaNacimiento":null,"fechaRegistro":"2026-09-09T22:15:26.685829","fechaActualizacion":"2026-09-12T18:21:17.502713","fechaEliminacion":null,"rol":"ADMIN","imagenUrl":null,"estado":"activo","intentosLoginFallidos":0},"Venta registrada","La venta PED-DE450F75 por S/ 74.14 se registró correctamente","VENTA","VENTA",16]	\N	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	2026-09-28 14:09:39.375639
205	1	CREAR	Venta	16	[{"tipoComprobante":"BOLETA","clienteId":null,"clienteNombre":"jose","apellidoCliente":"marcos","tipoDocumentoCliente":"DNI","dniCliente":"37475865","contacto":"938473847","emailCliente":"jose@gmail.com","departamento":"Lima","provincia":"Lima","distrito":"Barranco","direccionCliente":"av. los martines","referenciaCliente":"al costado","codigoPostalCliente":"1736","rucCliente":null,"razonSocialCliente":null,"entrega":"delivery","direccionEnvio":"av. los martines, Referencia: al costado, Barranco, Lima , Lima, C.P. 1736","sucursalId":null,"receptor":"marcos","dniReceptor":"84737475","costoDelivery":15,"metodoPago":"Yape","origen":null,"items":[{"productoId":206,"varianteId":112,"cantidad":1}]},1]	{"id":16,"codigo":"PED-DE450F75","tipoComprobante":"BOLETA","clienteId":6,"clienteNombre":"jose marcos","dniCliente":"37475865","contacto":"938473847","emailCliente":"jose@gmail.com","tipoDocumentoCliente":"DNI","rucCliente":null,"razonSocialCliente":null,"entrega":"delivery","direccionEnvio":"av. los martines, Referencia: al costado, Barranco, Lima , Lima, C.P. 1736","direccionCliente":"av. los martines","departamentoCliente":"Lima","provinciaCliente":"Lima","distritoCliente":"Barranco","referenciaCliente":"al costado","codigoPostalCliente":"1736","ciudadCliente":null,"paisCliente":null,"sucursalId":null,"sucursalNombre":null,"receptor":"marcos","dniReceptor":"84737475","costoDelivery":15,"subtotal":50.12,"baseImponible":50.12,"igv":9.02,"total":74.14,"metodoPago":"Yape","origen":"tienda_fisica","estado":"pendiente","clienteUsuarioId":null,"usuarioId":1,"nombreUsuario":"Administrador CeraMax","creadoEl":"2026-09-28T14:09:38.6361837","items":[{"id":19,"productoId":206,"nombre":"Plato de foca","descripcionCorta":"","skuVariante":"SVC001","precioBase":50.12,"precioAdicional":0.00,"precio":50.12,"cantidad":1,"subtotal":null,"atributosVariante":[{"varianteId":112,"valorId":10,"atributoId":3,"atributoNombre":"Color","valor":"Blanco"},{"varianteId":112,"valorId":32,"atributoId":7,"atributoNombre":"Forma","valor":"Foca"},{"varianteId":112,"valorId":36,"atributoId":12,"atributoNombre":"Tamaño","valor":"Mediano"}]}]}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	2026-09-28 14:09:40.223591
206	1	CREAR	Transportista	1	[{"nombre":"Olva Currier","sitioRastreoUrl":null}]	{"id":1,"nombre":"Olva Currier","sitioRastreoUrl":null,"estado":"activo"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	2026-09-28 14:14:49.047927
207	1	CREAR	Transportista	2	[{"nombre":"Shalom","sitioRastreoUrl":null}]	{"id":2,"nombre":"Shalom","sitioRastreoUrl":null,"estado":"activo"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	2026-09-28 14:15:09.990866
209	1	ACTUALIZAR	Venta	16	[16,"enviado"]	{"id":16,"codigo":"PED-DE450F75","tipoComprobante":"BOLETA","clienteId":6,"clienteNombre":"jose marcos","dniCliente":"37475865","contacto":"938473847","emailCliente":"jose@gmail.com","tipoDocumentoCliente":"DNI","rucCliente":null,"razonSocialCliente":null,"entrega":"delivery","direccionEnvio":"av. los martines, Referencia: al costado, Barranco, Lima , Lima, C.P. 1736","direccionCliente":"av. los martines","departamentoCliente":"Lima","provinciaCliente":"Lima","distritoCliente":"Barranco","referenciaCliente":"al costado","codigoPostalCliente":"1736","ciudadCliente":null,"paisCliente":null,"sucursalId":null,"sucursalNombre":null,"receptor":"marcos","dniReceptor":"84737475","costoDelivery":15.00,"subtotal":50.12,"baseImponible":50.12,"igv":9.02,"total":74.14,"metodoPago":"Yape","origen":"tienda_fisica","estado":"enviado","clienteUsuarioId":null,"usuarioId":1,"nombreUsuario":"Administrador CeraMax","creadoEl":"2026-09-28T14:09:38.636184","items":[{"id":19,"productoId":206,"nombre":"Plato de foca","descripcionCorta":"","skuVariante":"SVC001","precioBase":50.12,"precioAdicional":0.00,"precio":50.12,"cantidad":1,"subtotal":50.12,"atributosVariante":[{"varianteId":112,"valorId":10,"atributoId":3,"atributoNombre":"Color","valor":"Blanco"},{"varianteId":112,"valorId":32,"atributoId":7,"atributoNombre":"Forma","valor":"Foca"},{"varianteId":112,"valorId":36,"atributoId":12,"atributoNombre":"Tamaño","valor":"Mediano"}]}]}	cambiarEstado ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	2026-09-28 14:20:11.242343
97	1	ELIMINAR	Almacen	6	[6]	\N	eliminar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 09:05:19.456457
99	1	ELIMINAR	Almacen	1	[1]	\N	eliminar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 09:05:25.373612
100	1	ACTUALIZAR	Almacen	5	[5,{"nombre":"Almacen Central Lima","tipo":"principal","direccion":"Av. Argentina 2450","ciudad":"Lima","pais":"Peru","permiteRecojoCliente":true}]	{"id":5,"nombre":"Almacen Central Lima","tipo":"principal","direccion":"Av. Argentina 2450","ciudad":"Lima","pais":"Peru","permiteRecojoCliente":true,"estado":"activo"}	actualizar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 09:05:29.425952
101	1	ACTUALIZAR	Cupon	1	[1,{"codigo":"oferta30","tipoDescuento":"porcentaje","valor":12,"montoMinimoCompra":1222,"fechaInicio":"2026-09-13T00:00:00","fechaFin":"2026-09-18T23:59:59","usoMaximo":2}]	{"id":1,"codigo":"oferta30","tipoDescuento":"porcentaje","valor":12,"montoMinimoCompra":1222,"fechaInicio":"2026-09-13T00:00:00","fechaFin":"2026-09-18T23:59:59","usoMaximo":2,"usoActual":0,"estado":"activo"}	actualizar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 09:19:20.172986
102	1	ACTUALIZAR	Cupon	1	[1,{"codigo":"oferta30","tipoDescuento":"porcentaje","valor":12,"montoMinimoCompra":1222,"fechaInicio":"2026-09-13T00:00:00","fechaFin":"2026-09-16T23:59:59","usoMaximo":2}]	{"id":1,"codigo":"oferta30","tipoDescuento":"porcentaje","valor":12,"montoMinimoCompra":1222,"fechaInicio":"2026-09-13T00:00:00","fechaFin":"2026-09-16T23:59:59","usoMaximo":2,"usoActual":0,"estado":"activo"}	actualizar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 09:19:32.153231
103	1	ELIMINAR	ValorAtributo	1	[1]	\N	eliminar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 09:33:22.562525
104	1	CREAR	ValorAtributo	34	[{"atributoId":3,"valor":"Verde"}]	{"id":34,"atributoId":3,"atributoNombre":"Color","valor":"Verde"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 09:33:26.520335
98	1	ELIMINAR	Almacen	7	[7]	\N	eliminar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 09:05:22.542848
208	1	ACTUALIZAR	Venta	16	[16,"confirmado"]	{"id":16,"codigo":"PED-DE450F75","tipoComprobante":"BOLETA","clienteId":6,"clienteNombre":"jose marcos","dniCliente":"37475865","contacto":"938473847","emailCliente":"jose@gmail.com","tipoDocumentoCliente":"DNI","rucCliente":null,"razonSocialCliente":null,"entrega":"delivery","direccionEnvio":"av. los martines, Referencia: al costado, Barranco, Lima , Lima, C.P. 1736","direccionCliente":"av. los martines","departamentoCliente":"Lima","provinciaCliente":"Lima","distritoCliente":"Barranco","referenciaCliente":"al costado","codigoPostalCliente":"1736","ciudadCliente":null,"paisCliente":null,"sucursalId":null,"sucursalNombre":null,"receptor":"marcos","dniReceptor":"84737475","costoDelivery":15.00,"subtotal":50.12,"baseImponible":50.12,"igv":9.02,"total":74.14,"metodoPago":"Yape","origen":"tienda_fisica","estado":"confirmado","clienteUsuarioId":null,"usuarioId":1,"nombreUsuario":"Administrador CeraMax","creadoEl":"2026-09-28T14:09:38.636184","items":[{"id":19,"productoId":206,"nombre":"Plato de foca","descripcionCorta":"","skuVariante":"SVC001","precioBase":50.12,"precioAdicional":0.00,"precio":50.12,"cantidad":1,"subtotal":50.12,"atributosVariante":[{"varianteId":112,"valorId":10,"atributoId":3,"atributoNombre":"Color","valor":"Blanco"},{"varianteId":112,"valorId":32,"atributoId":7,"atributoNombre":"Forma","valor":"Foca"},{"varianteId":112,"valorId":36,"atributoId":12,"atributoNombre":"Tamaño","valor":"Mediano"}]}]}	cambiarEstado ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	2026-09-28 14:19:46.992841
95	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":6,"esObligatorio":true}]	{"categoriaId":25,"atributoId":6,"atributoNombre":"Días festivos","esObligatorio":true}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 08:55:52.576929
96	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":7,"esObligatorio":true}]	{"categoriaId":25,"atributoId":7,"atributoNombre":"Forma","esObligatorio":true}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 08:55:54.741255
105	1	CREAR	Atributo	12	[{"nombre":"Tamaño"}]	{"id":12,"nombre":"Tamaño","estado":"activo"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:46:02.658931
106	1	CREAR	ValorAtributo	35	[{"atributoId":12,"valor":"Grande"}]	{"id":35,"atributoId":12,"atributoNombre":"Tamaño","valor":"Grande"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:46:10.041111
107	1	CREAR	ValorAtributo	36	[{"atributoId":12,"valor":"Mediano"}]	{"id":36,"atributoId":12,"atributoNombre":"Tamaño","valor":"Mediano"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:46:14.721457
108	1	CREAR	ValorAtributo	37	[{"atributoId":12,"valor":"Pequeño"}]	{"id":37,"atributoId":12,"atributoNombre":"Tamaño","valor":"Pequeño"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:46:19.053396
109	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":12,"esObligatorio":false}]	{"categoriaId":25,"atributoId":12,"atributoNombre":"Tamaño","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:46:46.882882
110	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":7,"esObligatorio":false}]	{"categoriaId":25,"atributoId":7,"atributoNombre":"Forma","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:46:49.146854
111	1	CREAR	VarianteAtributo	108	[108,35]	{"varianteId":108,"valorId":35,"atributoId":12,"atributoNombre":"Tamaño","valor":"Grande"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:47:34.169785
112	1	CREAR	Variante	109	[{"productoId":206,"skuVariante":"dssd","codigoBarras":"sd","precioAdicional":12}]	{"id":109,"productoId":206,"productoNombre":"Plato de foca","skuVariante":"dssd","codigoBarras":"sd","precioAdicional":12,"estado":"activo"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:49:31.030033
113	1	ACTUALIZAR	Variante	109	[109,{"productoId":206,"skuVariante":"dssd","codigoBarras":"sd","precioAdicional":0}]	{"id":109,"productoId":206,"productoNombre":"Plato de foca","skuVariante":"dssd","codigoBarras":"sd","precioAdicional":0,"estado":"activo"}	actualizar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:49:54.98533
114	1	CREAR	VarianteAtributo	108	[108,20]	{"varianteId":108,"valorId":20,"atributoId":3,"atributoNombre":"Color","valor":"Marrón"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 09:56:46.222543
115	1	ACTUALIZAR	Variante	110	[110,{"productoId":207,"skuVariante":"sdfada","codigoBarras":null,"precioAdicional":0}]	{"id":110,"productoId":207,"productoNombre":"sada","skuVariante":"sdfada","codigoBarras":null,"precioAdicional":0,"estado":"activo"}	actualizar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:00:21.06612
116	1	CREAR	VarianteAtributo	110	[110,18]	{"varianteId":110,"valorId":18,"atributoId":3,"atributoNombre":"Color","valor":"Amarillo"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:00:27.971717
117	1	CREAR	VarianteAtributo	110	[110,35]	{"varianteId":110,"valorId":35,"atributoId":12,"atributoNombre":"Tamaño","valor":"Grande"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:06:50.291769
118	1	CREAR	Atributo	13	[{"nombre":"Formato"}]	{"id":13,"nombre":"Formato","estado":"activo"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:10:47.350509
119	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":3,"esObligatorio":false}]	{"categoriaId":25,"atributoId":3,"atributoNombre":"Color","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:16:57.513996
120	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":6,"esObligatorio":false}]	{"categoriaId":25,"atributoId":6,"atributoNombre":"Días festivos","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:16:59.374499
121	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":7,"esObligatorio":false}]	{"categoriaId":25,"atributoId":7,"atributoNombre":"Forma","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:17:01.729293
122	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":12,"esObligatorio":false}]	{"categoriaId":25,"atributoId":12,"atributoNombre":"Tamaño","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:17:20.366654
123	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":13,"esObligatorio":true}]	{"categoriaId":25,"atributoId":13,"atributoNombre":"Formato","esObligatorio":true}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:17:24.463076
130	1	ELIMINAR	Variante	109	[109]	\N	eliminar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:22:14.046934
124	1	ACTUALIZAR	Variante	109	[109,{"productoId":206,"skuVariante":"VSC002","codigoBarras":null,"precioAdicional":0}]	{"id":109,"productoId":206,"productoNombre":"Plato de foca","skuVariante":"VSC002","codigoBarras":null,"precioAdicional":0,"estado":"activo"}	actualizar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:18:08.618112
125	1	CREAR	ValorAtributo	38	[{"atributoId":13,"valor":"15.5 cm x 18.5 cm"}]	{"id":38,"atributoId":13,"atributoNombre":"Formato","valor":"15.5 cm x 18.5 cm"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:18:50.952405
126	1	ELIMINAR	Atributo	13	[13]	\N	eliminar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:20:22.846477
127	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":7,"esObligatorio":false}]	{"categoriaId":25,"atributoId":7,"atributoNombre":"Forma","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:20:38.411704
128	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":7,"esObligatorio":false}]	{"categoriaId":25,"atributoId":7,"atributoNombre":"Forma","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:20:50.700371
129	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":12,"esObligatorio":false}]	{"categoriaId":25,"atributoId":12,"atributoNombre":"Tamaño","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:20:56.433116
131	1	ELIMINAR	Variante	108	[108]	\N	eliminar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:22:18.149894
132	1	CREAR	Variante	112	[{"productoId":206,"skuVariante":"SVC001","codigoBarras":null,"precioAdicional":0}]	{"id":112,"productoId":206,"productoNombre":"Plato de foca","skuVariante":"SVC001","codigoBarras":null,"precioAdicional":0,"estado":"activo"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:41:24.355498
133	1	CREAR	VarianteAtributo	112	[112,12]	{"varianteId":112,"valorId":12,"atributoId":3,"atributoNombre":"Color","valor":"Azul"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:41:25.456724
134	1	CREAR	VarianteAtributo	112	[112,28]	{"varianteId":112,"valorId":28,"atributoId":7,"atributoNombre":"Forma","valor":"Redondo"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:41:26.481426
135	1	CREAR	VarianteAtributo	112	[112,35]	{"varianteId":112,"valorId":35,"atributoId":12,"atributoNombre":"Tamaño","valor":"Grande"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 10:41:28.119909
136	1	CREAR	Variante	113	[{"productoId":206,"skuVariante":"asas","codigoBarras":null,"precioAdicional":0}]	{"id":113,"productoId":206,"productoNombre":"Plato de foca","skuVariante":"asas","codigoBarras":null,"precioAdicional":0,"estado":"activo"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:13:16.260767
137	1	CREAR	VarianteAtributo	113	[113,10]	{"varianteId":113,"valorId":10,"atributoId":3,"atributoNombre":"Color","valor":"Blanco"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:13:17.508875
138	1	CREAR	Inventario	207	[{"varianteId":112,"almacenId":5,"stockMinimo":12,"stockMaximo":null,"puntoReorden":null,"permiteReposicion":null}]	{"id":207,"varianteId":112,"skuVariante":"SVC001","productoId":206,"nombreProducto":"Plato de foca","categoriaId":25,"almacenId":5,"nombreAlmacen":"Almacen Central Lima","cantidadDisponible":0,"cantidadReservada":0,"stockMinimo":12,"stockMaximo":null,"ultimaActualizacion":"2026-09-23T11:16:43.9651865"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:16:44.35886
139	1	CREAR	MovimientoInventario	4	[{"inventarioId":207,"tipoMovimiento":"entrada","cantidad":100,"motivo":"sss","referenciaDocumento":"","usuarioResponsableId":null}]	{"id":4,"inventarioId":207,"tipoMovimiento":"entrada","cantidad":100,"cantidadAntes":0,"cantidadDespues":100,"motivo":"sss","referenciaDocumento":"","usuarioResponsableId":null,"fechaMovimiento":"2026-09-23T11:17:21.4702605"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:17:21.630707
140	1	CREAR	Inventario	208	[{"varianteId":113,"almacenId":5,"stockMinimo":12,"stockMaximo":null,"puntoReorden":null,"permiteReposicion":null}]	{"id":208,"varianteId":113,"skuVariante":"asas","productoId":206,"nombreProducto":"Plato de foca","categoriaId":25,"almacenId":5,"nombreAlmacen":"Almacen Central Lima","cantidadDisponible":0,"cantidadReservada":0,"stockMinimo":12,"stockMaximo":null,"ultimaActualizacion":"2026-09-23T11:17:51.0312228"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:17:51.427451
141	1	CREAR	MovimientoInventario	5	[{"inventarioId":208,"tipoMovimiento":"entrada","cantidad":12,"motivo":"sss","referenciaDocumento":"","usuarioResponsableId":null}]	{"id":5,"inventarioId":208,"tipoMovimiento":"entrada","cantidad":12,"cantidadAntes":0,"cantidadDespues":12,"motivo":"sss","referenciaDocumento":"","usuarioResponsableId":null,"fechaMovimiento":"2026-09-23T11:19:19.376132"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:19:19.565163
142	1	CREAR	Notificacion	208	[{"id":1,"nombre":"Administrador","apellido":"CeraMax","email":"admin@ceramax.com","passwordHash":"$2a$10$LhgGim88M7ZLtpMUq21YT.7BIR/NlZ4MprriNLOscigQrOwnYF86i","tipoDocumento":null,"numeroDocumento":null,"telefono":null,"fechaNacimiento":null,"fechaRegistro":"2026-09-09T22:15:26.685829","fechaActualizacion":"2026-09-12T18:21:17.502713","fechaEliminacion":null,"rol":"ADMIN","imagenUrl":null,"estado":"activo","intentosLoginFallidos":0},"Stock bajo","Plato de foca quedó con 2 unidades en Almacen Central Lima","STOCK","INVENTARIO",208]	\N	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:19:41.533601
210	1	CREAR	Envio	8	[{"pedidoId":16,"transportistaId":null,"numeroSeguimiento":null,"fechaEntregaEstimada":null}]	{"id":8,"pedidoId":16,"transportistaId":null,"transportistaNombre":null,"numeroSeguimiento":null,"costoEnvio":15.00,"estadoPedido":"pendiente","tipoEntrega":"delivery","fechaEnvio":null,"fechaEntregaEstimada":null,"fechaEntregaReal":null}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.139.1 Chrome/150.0.7871.250 Electron/43.6.0 Safari/537.36	2026-09-28 15:15:49.180864
143	1	CREAR	MovimientoInventario	6	[{"inventarioId":208,"tipoMovimiento":"salida","cantidad":10,"motivo":"2sss","referenciaDocumento":"","usuarioResponsableId":null}]	{"id":6,"inventarioId":208,"tipoMovimiento":"salida","cantidad":10,"cantidadAntes":12,"cantidadDespues":2,"motivo":"2sss","referenciaDocumento":"","usuarioResponsableId":null,"fechaMovimiento":"2026-09-23T11:19:41.5286077"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:19:41.712852
144	1	ACTUALIZAR	Variante	113	[113,{"productoId":206,"skuVariante":"SVC002","codigoBarras":null,"precioAdicional":20}]	{"id":113,"productoId":206,"productoNombre":"Plato de foca","skuVariante":"SVC002","codigoBarras":null,"precioAdicional":20,"estado":"activo"}	actualizar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:35:02.371956
145	1	CREAR	VarianteAtributo	113	[113,25]	{"varianteId":113,"valorId":25,"atributoId":6,"atributoNombre":"Días festivos","valor":"Halloween"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:35:27.136652
146	1	CREAR	VarianteAtributo	113	[113,35]	{"varianteId":113,"valorId":35,"atributoId":12,"atributoNombre":"Tamaño","valor":"Grande"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:35:28.43258
147	1	CREAR	VarianteAtributo	113	[113,32]	{"varianteId":113,"valorId":32,"atributoId":7,"atributoNombre":"Forma","valor":"Foca"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:35:29.779477
148	1	CREAR	Notificacion	13	[{"id":1,"nombre":"Administrador","apellido":"CeraMax","email":"admin@ceramax.com","passwordHash":"$2a$10$LhgGim88M7ZLtpMUq21YT.7BIR/NlZ4MprriNLOscigQrOwnYF86i","tipoDocumento":null,"numeroDocumento":null,"telefono":null,"fechaNacimiento":null,"fechaRegistro":"2026-09-09T22:15:26.685829","fechaActualizacion":"2026-09-12T18:21:17.502713","fechaEliminacion":null,"rol":"ADMIN","imagenUrl":null,"estado":"activo","intentosLoginFallidos":0},"Venta registrada","La venta PED-FD86D4F1 por S/ 156.88 se registró correctamente","VENTA","VENTA",13]	\N	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:37:44.715246
149	1	CREAR	Venta	13	[{"tipoComprobante":"BOLETA","clienteId":5,"clienteNombre":"ASDAD","dniCliente":"13131321","contacto":"123123","emailCliente":null,"rucCliente":null,"razonSocialCliente":null,"entrega":"delivery","direccionEnvio":"ASDASDASD","sucursalId":null,"receptor":"ASDASD","dniReceptor":"1231313","costoDelivery":15,"metodoPago":"Tarjeta de crédito/débito","origen":null,"items":[{"productoId":206,"varianteId":113,"cantidad":1},{"productoId":206,"varianteId":112,"cantidad":1}]},1]	{"id":13,"codigo":"PED-FD86D4F1","tipoComprobante":"BOLETA","clienteId":5,"clienteNombre":"ASDAD ADAD","dniCliente":"13131321","contacto":"123123","entrega":"delivery","direccionEnvio":"ASDASDASD","sucursalId":null,"sucursalNombre":null,"receptor":"ASDASD","dniReceptor":"1231313","costoDelivery":15,"subtotal":120.24,"baseImponible":120.24,"igv":21.64,"total":156.88,"metodoPago":"Tarjeta de crédito/débito","origen":"tienda_fisica","estado":"pendiente","usuarioId":1,"nombreUsuario":"Administrador CeraMax","creadoEl":"2026-09-23T11:37:43.6092448","items":[{"id":14,"productoId":206,"nombre":"Plato de foca","precio":70.12,"cantidad":1,"subtotal":null},{"id":15,"productoId":206,"nombre":"Plato de foca","precio":50.12,"cantidad":1,"subtotal":null}]}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:37:45.334165
150	1	CREAR	VarianteAtributo	112	[112,25]	{"varianteId":112,"valorId":25,"atributoId":6,"atributoNombre":"Días festivos","valor":"Halloween"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:45:48.257086
151	1	CREAR	VarianteAtributo	112	[112,31]	{"varianteId":112,"valorId":31,"atributoId":7,"atributoNombre":"Forma","valor":"Cuadrado"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:45:50.303801
152	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":12,"esObligatorio":true}]	{"categoriaId":25,"atributoId":12,"atributoNombre":"Tamaño","esObligatorio":true}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:46:08.639076
153	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":3,"esObligatorio":false}]	{"categoriaId":25,"atributoId":3,"atributoNombre":"Color","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:46:11.502252
154	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":6,"esObligatorio":false}]	{"categoriaId":25,"atributoId":6,"atributoNombre":"Días festivos","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:46:13.85769
155	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":7,"esObligatorio":false}]	{"categoriaId":25,"atributoId":7,"atributoNombre":"Forma","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:46:15.496408
156	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":3,"esObligatorio":true}]	{"categoriaId":25,"atributoId":3,"atributoNombre":"Color","esObligatorio":true}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:46:48.797686
157	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":6,"esObligatorio":true}]	{"categoriaId":25,"atributoId":6,"atributoNombre":"Días festivos","esObligatorio":true}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:46:51.336594
158	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":7,"esObligatorio":true}]	{"categoriaId":25,"atributoId":7,"atributoNombre":"Forma","esObligatorio":true}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:46:55.138013
159	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":12,"esObligatorio":false}]	{"categoriaId":25,"atributoId":12,"atributoNombre":"Tamaño","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:46:57.934131
160	1	CREAR	VarianteAtributo	113	[113,12]	{"varianteId":113,"valorId":12,"atributoId":3,"atributoNombre":"Color","valor":"Azul"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:47:19.188315
211	1	ACTUALIZAR	Envio	8	[8,"en_camino"]	{"id":8,"pedidoId":16,"transportistaId":null,"transportistaNombre":null,"numeroSeguimiento":null,"costoEnvio":15.00,"estadoPedido":"en_camino","tipoEntrega":"delivery","fechaEnvio":"2026-09-28T15:20:00.4069194","fechaEntregaEstimada":null,"fechaEntregaReal":null}	cambiarEstado ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	2026-09-28 15:20:00.433076
161	1	CREAR	VarianteAtributo	113	[113,31]	{"varianteId":113,"valorId":31,"atributoId":7,"atributoNombre":"Forma","valor":"Cuadrado"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 11:47:23.38715
162	1	CREAR	Notificacion	14	[{"id":1,"nombre":"Administrador","apellido":"CeraMax","email":"admin@ceramax.com","passwordHash":"$2a$10$LhgGim88M7ZLtpMUq21YT.7BIR/NlZ4MprriNLOscigQrOwnYF86i","tipoDocumento":null,"numeroDocumento":null,"telefono":null,"fechaNacimiento":null,"fechaRegistro":"2026-09-09T22:15:26.685829","fechaActualizacion":"2026-09-12T18:21:17.502713","fechaEliminacion":null,"rol":"ADMIN","imagenUrl":null,"estado":"activo","intentosLoginFallidos":0},"Venta registrada","La venta PED-C8E26886 por S/ 153.88 se registró correctamente","VENTA","VENTA",14]	\N	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 12:24:10.674626
163	1	CREAR	Venta	14	[{"tipoComprobante":"BOLETA","clienteId":5,"clienteNombre":"ASDAD","dniCliente":"13131321","contacto":"123123","emailCliente":null,"rucCliente":null,"razonSocialCliente":null,"entrega":"delivery","direccionEnvio":"adasdsa","sucursalId":null,"receptor":"aadadad","dniReceptor":"1231231","costoDelivery":12,"metodoPago":"Tarjeta de crédito/débito","origen":null,"items":[{"productoId":206,"varianteId":113,"cantidad":1},{"productoId":206,"varianteId":112,"cantidad":1}]},1]	{"id":14,"codigo":"PED-C8E26886","tipoComprobante":"BOLETA","clienteId":5,"clienteNombre":"ASDAD ADAD","dniCliente":"13131321","contacto":"123123","entrega":"delivery","direccionEnvio":"adasdsa","sucursalId":null,"sucursalNombre":null,"receptor":"aadadad","dniReceptor":"1231231","costoDelivery":12,"subtotal":120.24,"baseImponible":120.24,"igv":21.64,"total":153.88,"metodoPago":"Tarjeta de crédito/débito","origen":"tienda_fisica","estado":"pendiente","usuarioId":1,"nombreUsuario":"Administrador CeraMax","creadoEl":"2026-09-23T12:24:09.3322034","items":[{"id":16,"productoId":206,"nombre":"Plato de foca","skuVariante":"SVC002","precioBase":50.12,"precioAdicional":20.00,"precio":70.12,"cantidad":1,"subtotal":null},{"id":17,"productoId":206,"nombre":"Plato de foca","skuVariante":"SVC001","precioBase":50.12,"precioAdicional":0.00,"precio":50.12,"cantidad":1,"subtotal":null}]}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 12:24:11.082536
164	1	CREAR	Notificacion	15	[{"id":1,"nombre":"Administrador","apellido":"CeraMax","email":"admin@ceramax.com","passwordHash":"$2a$10$LhgGim88M7ZLtpMUq21YT.7BIR/NlZ4MprriNLOscigQrOwnYF86i","tipoDocumento":null,"numeroDocumento":null,"telefono":null,"fechaNacimiento":null,"fechaRegistro":"2026-09-09T22:15:26.685829","fechaActualizacion":"2026-09-12T18:21:17.502713","fechaEliminacion":null,"rol":"ADMIN","imagenUrl":null,"estado":"activo","intentosLoginFallidos":0},"Venta registrada","La venta PED-AFB39779 por S/ 177.42 se registró correctamente","VENTA","VENTA",15]	\N	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 12:32:28.59001
165	1	CREAR	Venta	15	[{"tipoComprobante":"BOLETA","clienteId":5,"clienteNombre":"ASDAD","dniCliente":"13131321","contacto":"123123","emailCliente":null,"rucCliente":null,"razonSocialCliente":null,"entrega":"recojo","direccionEnvio":null,"sucursalId":2,"receptor":"asddds","dniReceptor":"12313","costoDelivery":0,"metodoPago":"Tarjeta de crédito/débito","origen":null,"items":[{"productoId":206,"varianteId":112,"cantidad":3}]},1]	{"id":15,"codigo":"PED-AFB39779","tipoComprobante":"BOLETA","clienteId":5,"clienteNombre":"ASDAD ADAD","dniCliente":"13131321","contacto":"123123","entrega":"recojo","direccionEnvio":null,"sucursalId":2,"sucursalNombre":"Sucursal Principal","receptor":"asddds","dniReceptor":"12313","costoDelivery":0,"subtotal":150.36,"baseImponible":150.36,"igv":27.06,"total":177.42,"metodoPago":"Tarjeta de crédito/débito","origen":"tienda_fisica","estado":"pendiente","usuarioId":1,"nombreUsuario":"Administrador CeraMax","creadoEl":"2026-09-23T12:32:27.4234776","items":[{"id":18,"productoId":206,"nombre":"Plato de foca","skuVariante":"SVC001","precioBase":50.12,"precioAdicional":0.00,"precio":50.12,"cantidad":3,"subtotal":null,"atributosVariante":[{"varianteId":112,"valorId":12,"atributoId":3,"atributoNombre":"Color","valor":"Azul"},{"varianteId":112,"valorId":25,"atributoId":6,"atributoNombre":"Días festivos","valor":"Halloween"},{"varianteId":112,"valorId":31,"atributoId":7,"atributoNombre":"Forma","valor":"Cuadrado"}]}]}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36	2026-09-23 12:32:29.885782
166	1	CREAR	VarianteAtributo	112	[112,10]	{"varianteId":112,"valorId":10,"atributoId":3,"atributoNombre":"Color","valor":"Blanco"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 12:56:22.176376
167	1	CREAR	VarianteAtributo	112	[112,32]	{"varianteId":112,"valorId":32,"atributoId":7,"atributoNombre":"Forma","valor":"Foca"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 12:56:26.997442
168	1	CREAR	VarianteAtributo	112	[112,27]	{"varianteId":112,"valorId":27,"atributoId":6,"atributoNombre":"Días festivos","valor":"Día del Padre"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 12:56:44.028533
169	1	CREAR	VarianteAtributo	113	[113,10]	{"varianteId":113,"valorId":10,"atributoId":3,"atributoNombre":"Color","valor":"Blanco"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 12:57:00.465743
170	1	CREAR	VarianteAtributo	113	[113,32]	{"varianteId":113,"valorId":32,"atributoId":7,"atributoNombre":"Forma","valor":"Foca"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 12:57:03.487815
171	1	CREAR	VarianteAtributo	113	[113,27]	{"varianteId":113,"valorId":27,"atributoId":6,"atributoNombre":"Días festivos","valor":"Día del Padre"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 12:57:05.891828
172	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":25,"atributoId":6,"esObligatorio":false}]	{"categoriaId":25,"atributoId":6,"atributoNombre":"Días festivos","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 12:57:39.786663
173	1	CREAR	VarianteAtributo	112	[112,36]	{"varianteId":112,"valorId":36,"atributoId":12,"atributoNombre":"Tamaño","valor":"Mediano"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 12:58:39.283911
174	1	CREAR	Imagen	16	[{"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186613/ceramax/producto/bandeja-de-huevo/imagenes/j6wfomzydthjqevuqqdt.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/j6wfomzydthjqevuqqdt","esPrincipal":false,"orden":0}]	{"id":16,"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186613/ceramax/producto/bandeja-de-huevo/imagenes/j6wfomzydthjqevuqqdt.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/j6wfomzydthjqevuqqdt","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:03:35.02334
175	1	CREAR	Imagen	17	[{"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186616/ceramax/producto/bandeja-de-huevo/imagenes/z1ffowvwmmopa1kdr5wq.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/z1ffowvwmmopa1kdr5wq","esPrincipal":false,"orden":0}]	{"id":17,"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186616/ceramax/producto/bandeja-de-huevo/imagenes/z1ffowvwmmopa1kdr5wq.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/z1ffowvwmmopa1kdr5wq","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:03:37.478379
198	1	CREAR	ValorAtributo	39	[{"atributoId":7,"valor":"Pez"}]	{"id":39,"atributoId":7,"atributoNombre":"Forma","valor":"Pez"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:15:26.097679
199	1	CREAR	ValorAtributo	40	[{"atributoId":7,"valor":"Rectángulo"}]	{"id":40,"atributoId":7,"atributoNombre":"Forma","valor":"Rectángulo"}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:15:40.157794
212	1	ACTUALIZAR	Envio	8	[8,"entregado"]	{"id":8,"pedidoId":16,"transportistaId":null,"transportistaNombre":null,"numeroSeguimiento":null,"costoEnvio":15.00,"estadoPedido":"entregado","tipoEntrega":"delivery","fechaEnvio":"2026-09-28T15:20:00.406919","fechaEntregaEstimada":null,"fechaEntregaReal":"2026-09-28T15:20:17.5015075"}	cambiarEstado ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36	2026-09-28 15:20:17.501508
176	1	CREAR	Imagen	18	[{"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186618/ceramax/producto/bandeja-de-huevo/imagenes/eccjyza7j6ueztctfd1z.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/eccjyza7j6ueztctfd1z","esPrincipal":false,"orden":0}]	{"id":18,"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186618/ceramax/producto/bandeja-de-huevo/imagenes/eccjyza7j6ueztctfd1z.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/eccjyza7j6ueztctfd1z","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:03:40.442779
177	1	CREAR	Imagen	19	[{"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186621/ceramax/producto/bandeja-de-huevo/imagenes/nafxt3fb5pwguuhdnqna.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/nafxt3fb5pwguuhdnqna","esPrincipal":false,"orden":0}]	{"id":19,"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186621/ceramax/producto/bandeja-de-huevo/imagenes/nafxt3fb5pwguuhdnqna.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/nafxt3fb5pwguuhdnqna","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:03:42.597099
178	1	CREAR	Imagen	20	[{"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186623/ceramax/producto/bandeja-de-huevo/imagenes/outajqlhyzrfpmvsja17.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/outajqlhyzrfpmvsja17","esPrincipal":false,"orden":0}]	{"id":20,"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186623/ceramax/producto/bandeja-de-huevo/imagenes/outajqlhyzrfpmvsja17.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/outajqlhyzrfpmvsja17","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:03:45.116824
179	1	CREAR	Imagen	21	[{"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186626/ceramax/producto/bandeja-de-huevo/imagenes/wzvarojh9oagf76lcudu.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/wzvarojh9oagf76lcudu","esPrincipal":false,"orden":0}]	{"id":21,"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186626/ceramax/producto/bandeja-de-huevo/imagenes/wzvarojh9oagf76lcudu.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/wzvarojh9oagf76lcudu","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:03:47.512591
180	1	CREAR	Imagen	22	[{"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186628/ceramax/producto/bandeja-de-huevo/imagenes/aushwdmtgwek5giid0xm.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/aushwdmtgwek5giid0xm","esPrincipal":false,"orden":0}]	{"id":22,"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186628/ceramax/producto/bandeja-de-huevo/imagenes/aushwdmtgwek5giid0xm.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/aushwdmtgwek5giid0xm","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:03:49.988677
181	1	CREAR	Imagen	23	[{"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186631/ceramax/producto/bandeja-de-huevo/imagenes/gwimhdxcd7mkqgohnwgo.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/gwimhdxcd7mkqgohnwgo","esPrincipal":false,"orden":0}]	{"id":23,"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186631/ceramax/producto/bandeja-de-huevo/imagenes/gwimhdxcd7mkqgohnwgo.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/gwimhdxcd7mkqgohnwgo","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:03:52.124923
182	1	CREAR	Imagen	24	[{"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186633/ceramax/producto/bandeja-de-huevo/imagenes/r7guugstnj99ut1conle.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/r7guugstnj99ut1conle","esPrincipal":false,"orden":0}]	{"id":24,"productoId":209,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790186633/ceramax/producto/bandeja-de-huevo/imagenes/r7guugstnj99ut1conle.jpg","imagenPublicId":"ceramax/producto/bandeja-de-huevo/imagenes/r7guugstnj99ut1conle","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:03:54.782435
183	1	ACTUALIZAR	Variante	114	[114,{"productoId":209,"skuVariante":"SVCH001","codigoBarras":null,"precioAdicional":0}]	{"id":114,"productoId":209,"productoNombre":"Bandeja de Huevo","skuVariante":"SVCH001","codigoBarras":null,"precioAdicional":0,"estado":"activo","atributos":[]}	actualizar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:04:15.373047
184	1	CREAR	VarianteAtributo	114	[114,10]	{"varianteId":114,"valorId":10,"atributoId":3,"atributoNombre":"Color","valor":"Blanco"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:04:24.987113
185	1	CREAR	VarianteAtributo	114	[114,29]	{"varianteId":114,"valorId":29,"atributoId":7,"atributoNombre":"Forma","valor":"Oval"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:04:27.449792
186	1	CREAR	VarianteAtributo	114	[114,24]	{"varianteId":114,"valorId":24,"atributoId":6,"atributoNombre":"Días festivos","valor":"Navidad"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:04:29.93994
187	1	CREAR	VarianteAtributo	114	[114,36]	{"varianteId":114,"valorId":36,"atributoId":12,"atributoNombre":"Tamaño","valor":"Mediano"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:04:36.454574
192	1	CREAR	VarianteAtributo	115	[115,10]	{"varianteId":115,"valorId":10,"atributoId":3,"atributoNombre":"Color","valor":"Blanco"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:11:31.722071
188	1	CREAR	Imagen	26	[{"productoId":210,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790187047/ceramax/producto/juego-de-platos-para-postre/imagenes/q7mf1h9zkb5zhhfe0faq.avif","imagenPublicId":"ceramax/producto/juego-de-platos-para-postre/imagenes/q7mf1h9zkb5zhhfe0faq","esPrincipal":false,"orden":0}]	{"id":26,"productoId":210,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790187047/ceramax/producto/juego-de-platos-para-postre/imagenes/q7mf1h9zkb5zhhfe0faq.avif","imagenPublicId":"ceramax/producto/juego-de-platos-para-postre/imagenes/q7mf1h9zkb5zhhfe0faq","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:10:48.794205
189	1	CREAR	Imagen	27	[{"productoId":210,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790187049/ceramax/producto/juego-de-platos-para-postre/imagenes/ckt6akh2sx0h8wx0eegd.avif","imagenPublicId":"ceramax/producto/juego-de-platos-para-postre/imagenes/ckt6akh2sx0h8wx0eegd","esPrincipal":false,"orden":0}]	{"id":27,"productoId":210,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790187049/ceramax/producto/juego-de-platos-para-postre/imagenes/ckt6akh2sx0h8wx0eegd.avif","imagenPublicId":"ceramax/producto/juego-de-platos-para-postre/imagenes/ckt6akh2sx0h8wx0eegd","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:10:50.328873
190	1	CREAR	Imagen	28	[{"productoId":210,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790187050/ceramax/producto/juego-de-platos-para-postre/imagenes/hwmvkfzbodimkowfhglh.avif","imagenPublicId":"ceramax/producto/juego-de-platos-para-postre/imagenes/hwmvkfzbodimkowfhglh","esPrincipal":false,"orden":0}]	{"id":28,"productoId":210,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790187050/ceramax/producto/juego-de-platos-para-postre/imagenes/hwmvkfzbodimkowfhglh.avif","imagenPublicId":"ceramax/producto/juego-de-platos-para-postre/imagenes/hwmvkfzbodimkowfhglh","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:10:52.097955
191	1	CREAR	Imagen	29	[{"productoId":210,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790187052/ceramax/producto/juego-de-platos-para-postre/imagenes/fo8f7kydq3kelftsmzko.avif","imagenPublicId":"ceramax/producto/juego-de-platos-para-postre/imagenes/fo8f7kydq3kelftsmzko","esPrincipal":false,"orden":0}]	{"id":29,"productoId":210,"varianteId":null,"urlImagen":"https://res.cloudinary.com/dfmveqhud/image/upload/v1790187052/ceramax/producto/juego-de-platos-para-postre/imagenes/fo8f7kydq3kelftsmzko.avif","imagenPublicId":"ceramax/producto/juego-de-platos-para-postre/imagenes/fo8f7kydq3kelftsmzko","esPrincipal":false,"orden":0}	crear ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:10:54.11728
196	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":27,"atributoId":3,"esObligatorio":false}]	{"categoriaId":27,"atributoId":3,"atributoNombre":"Color","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:15:04.422018
200	1	ACTUALIZAR	Variante	116	[116,{"productoId":211,"skuVariante":"SVT001","codigoBarras":null,"precioAdicional":0}]	{"id":116,"productoId":211,"productoNombre":"Taza de cerámica vintage","skuVariante":"SVT001","codigoBarras":null,"precioAdicional":0,"estado":"activo","atributos":[]}	actualizar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:22:12.723429
193	1	CREAR	VarianteAtributo	115	[115,29]	{"varianteId":115,"valorId":29,"atributoId":7,"atributoNombre":"Forma","valor":"Oval"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:11:40.708889
194	1	CREAR	VarianteAtributo	115	[115,26]	{"varianteId":115,"valorId":26,"atributoId":6,"atributoNombre":"Días festivos","valor":"Día de la Madre"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:11:43.988405
195	1	CREAR	VarianteAtributo	115	[115,36]	{"varianteId":115,"valorId":36,"atributoId":12,"atributoNombre":"Tamaño","valor":"Mediano"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:11:46.369595
197	1	CREAR	CategoriaAtributo	\N	[{"categoriaId":27,"atributoId":7,"esObligatorio":false}]	{"categoriaId":27,"atributoId":7,"atributoNombre":"Forma","esObligatorio":false}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:15:12.434475
203	1	CREAR	VarianteAtributo	116	[116,29]	{"varianteId":116,"valorId":29,"atributoId":7,"atributoNombre":"Forma","valor":"Oval"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:23:03.410916
201	1	CREAR	VarianteAtributo	116	[116,20]	{"varianteId":116,"valorId":20,"atributoId":3,"atributoNombre":"Color","valor":"Marrón"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:22:29.823633
202	1	CREAR	VarianteAtributo	116	[116,19]	{"varianteId":116,"valorId":19,"atributoId":3,"atributoNombre":"Color","valor":"Naranja"}	asignar ejecutado	0:0:0:0:0:0:0:1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36	2026-09-23 13:23:00.333775
\.


--
-- Data for Name: carritos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.carritos (id_carrito, id_usuario, session_id, estado, fecha_creacion, fecha_actualizacion) FROM stdin;
\.


--
-- Data for Name: categoria_atributos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.categoria_atributos (id_categoria, id_atributo, es_obligatorio) FROM stdin;
25	3	t
25	7	t
25	12	f
25	6	f
27	3	f
27	7	f
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.categorias (id_categoria, id_categoria_padre, nombre, slug, descripcion, imagen_url, imagen_public_id, orden, estado) FROM stdin;
25	\N	Sala y comedor	sala-y-comedor	Encuentra los adornos decorativos perfectos para tu sala, comedor o dormitorio. ¡Crea ambientes cálidos y acogedores con nuestros adornos para el hogar!	https://res.cloudinary.com/dfmveqhud/image/upload/v1790165403/ceramax/categorias/sala-y-comedor/imagenes/hjj54m31pju5btns77ds.jpg	ceramax/categorias/sala-y-comedor/imagenes/hjj54m31pju5btns77ds	0	activo
27	\N	Accesorios para cafe	accesorios-para-cafe	La mejor manera de tomar un buen café es con un vaso cálido hecho en mano	https://res.cloudinary.com/dfmveqhud/image/upload/v1790187265/ceramax/categorias/accesorios-para-cafe/imagenes/pv1nnbni3jq7vpl1ktxh.avif	ceramax/categorias/accesorios-para-cafe/imagenes/pv1nnbni3jq7vpl1ktxh	0	activo
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.clientes (id_cliente, tipo_documento, numero_documento, nombre, apellido, telefono, email, ruc, razon_social, estado, fecha_registro, fecha_actualizacion, departamento, provincia, distrito, direccion, referencia, codigo_postal, password_hash) FROM stdin;
1	\N	\N	Cliente	Prueba	\N	cliente@test.com	\N	\N	activo	2026-09-12 13:15:25.869198	2026-09-12 13:15:25.869198	\N	\N	\N	\N	\N	\N	\N
4	RUC	20123456789	Almacenes XYZ	SAC	555666	alm2@test.com	20123456789	Almacenes XYZ S.A.C.	inactivo	2026-09-18 02:10:15.334207	2026-09-18 02:12:44.867178	\N	\N	\N	\N	\N	\N	\N
2	DNI	70903432	Cliente	CeraMax	\N	cliente@ceramax.com	\N	\N	inactivo	2026-09-09 22:15:26.685829	2026-09-23 11:31:31.578428	\N	\N	\N	\N	\N	\N	\N
5	DNI	13131321	ASDAD	ADAD	123123	\N	\N	\N	activo	2026-09-23 11:37:42.155024	2026-09-23 11:37:42.155024	\N	\N	\N	\N	\N	\N	\N
6	DNI	37475865	jose	marcos	938473847	jose@gmail.com	\N	\N	activo	2026-09-28 14:09:38.154841	2026-09-28 14:09:38.154841	Lima	Lima	Barranco	av. los martines	al costado	1736	\N
\.


--
-- Data for Name: configuracion_tienda; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.configuracion_tienda (id_configuracion, nombre_tienda, moneda, pais_operacion, porcentaje_impuesto_default, permite_venta_presencial, permite_recojo_tienda) FROM stdin;
1	CeraMax	PEN	Peru	1.80	t	t
\.


--
-- Data for Name: cupones; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.cupones (id_cupon, codigo, tipo_descuento, valor, monto_minimo_compra, fecha_inicio, fecha_fin, uso_maximo, uso_actual, estado) FROM stdin;
1	oferta30	porcentaje	12.00	1222.00	2026-09-13 00:00:00	2026-09-16 23:59:59	2	0	activo
\.


--
-- Data for Name: detalle_carrito; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.detalle_carrito (id_detalle_carrito, id_carrito, id_variante, cantidad, precio_unitario_momento, fecha_agregado) FROM stdin;
\.


--
-- Data for Name: detalle_orden_compra; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.detalle_orden_compra (id_detalle, id_orden_compra, id_variante, cantidad_solicitada, cantidad_recibida, costo_unitario) FROM stdin;
\.


--
-- Data for Name: detalle_pedido; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.detalle_pedido (id_detalle_pedido, id_pedido, id_variante, id_almacen, sku_snapshot, nombre_producto_snapshot, cantidad, precio_unitario) FROM stdin;
19	16	112	5	SVC001	Plato de foca	1	50.12
\.


--
-- Data for Name: devoluciones; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.devoluciones (id_devolucion, id_pedido, id_detalle_pedido, cantidad, motivo, estado, monto_reembolso, fecha_solicitud, fecha_resolucion) FROM stdin;
\.


--
-- Data for Name: direcciones; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.direcciones (id_direccion, id_usuario, tipo, calle, numero_ext, colonia_sector, ciudad, estado_provincia, codigo_postal, pais, telefono_contacto, es_predeterminada) FROM stdin;
\.


--
-- Data for Name: envios; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.envios (id_envio, id_pedido, id_transportista, numero_seguimiento, costo_envio, fecha_envio, fecha_entrega_estimada, fecha_entrega_real) FROM stdin;
8	16	\N	\N	15.00	2026-09-28 15:20:00.406919	\N	2026-09-28 15:20:17.501508
\.


--
-- Data for Name: imagenes_categoria; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.imagenes_categoria (id_imagen_categoria, id_categoria, url_imagen, imagen_public_id, es_principal, orden) FROM stdin;
\.


--
-- Data for Name: imagenes_producto; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.imagenes_producto (id_imagen, id_producto, id_variante, url_imagen, imagen_public_id, es_principal, orden) FROM stdin;
5	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168977/ceramax/producto/plato-de-foca/imagenes/pmhlahatyvsyswwe6mmj.jpg	ceramax/producto/plato-de-foca/imagenes/pmhlahatyvsyswwe6mmj	t	0
6	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168981/ceramax/producto/plato-de-foca/imagenes/acomgaowdnwwaaohpyp2.jpg	ceramax/producto/plato-de-foca/imagenes/acomgaowdnwwaaohpyp2	f	0
7	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168983/ceramax/producto/plato-de-foca/imagenes/sn3doy2dflx7ccmwfpvt.jpg	ceramax/producto/plato-de-foca/imagenes/sn3doy2dflx7ccmwfpvt	f	0
8	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168985/ceramax/producto/plato-de-foca/imagenes/ycpan7nv5rtckfnnxdob.jpg	ceramax/producto/plato-de-foca/imagenes/ycpan7nv5rtckfnnxdob	f	0
9	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168988/ceramax/producto/plato-de-foca/imagenes/gfhwmkyvogvkt0og6sta.jpg	ceramax/producto/plato-de-foca/imagenes/gfhwmkyvogvkt0og6sta	f	0
10	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168990/ceramax/producto/plato-de-foca/imagenes/vgtivuvinfjwbdsb1mqh.jpg	ceramax/producto/plato-de-foca/imagenes/vgtivuvinfjwbdsb1mqh	f	0
11	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168992/ceramax/producto/plato-de-foca/imagenes/faduumy7zwq4qrsg0uze.jpg	ceramax/producto/plato-de-foca/imagenes/faduumy7zwq4qrsg0uze	f	0
12	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168994/ceramax/producto/plato-de-foca/imagenes/l0xazcfnxykfl8a9rwca.jpg	ceramax/producto/plato-de-foca/imagenes/l0xazcfnxykfl8a9rwca	f	0
13	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168996/ceramax/producto/plato-de-foca/imagenes/zu3wv5ypnx5lqcggjgek.jpg	ceramax/producto/plato-de-foca/imagenes/zu3wv5ypnx5lqcggjgek	f	0
14	206	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790168999/ceramax/producto/plato-de-foca/imagenes/atufyudvrbwfzrq7xtn3.jpg	ceramax/producto/plato-de-foca/imagenes/atufyudvrbwfzrq7xtn3	f	0
15	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186608/ceramax/producto/bandeja-de-huevo/imagenes/c5mfatinimqrx9vrdsdf.jpg	ceramax/producto/bandeja-de-huevo/imagenes/c5mfatinimqrx9vrdsdf	t	0
16	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186613/ceramax/producto/bandeja-de-huevo/imagenes/j6wfomzydthjqevuqqdt.jpg	ceramax/producto/bandeja-de-huevo/imagenes/j6wfomzydthjqevuqqdt	f	0
17	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186616/ceramax/producto/bandeja-de-huevo/imagenes/z1ffowvwmmopa1kdr5wq.jpg	ceramax/producto/bandeja-de-huevo/imagenes/z1ffowvwmmopa1kdr5wq	f	0
18	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186618/ceramax/producto/bandeja-de-huevo/imagenes/eccjyza7j6ueztctfd1z.jpg	ceramax/producto/bandeja-de-huevo/imagenes/eccjyza7j6ueztctfd1z	f	0
19	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186621/ceramax/producto/bandeja-de-huevo/imagenes/nafxt3fb5pwguuhdnqna.jpg	ceramax/producto/bandeja-de-huevo/imagenes/nafxt3fb5pwguuhdnqna	f	0
20	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186623/ceramax/producto/bandeja-de-huevo/imagenes/outajqlhyzrfpmvsja17.jpg	ceramax/producto/bandeja-de-huevo/imagenes/outajqlhyzrfpmvsja17	f	0
21	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186626/ceramax/producto/bandeja-de-huevo/imagenes/wzvarojh9oagf76lcudu.jpg	ceramax/producto/bandeja-de-huevo/imagenes/wzvarojh9oagf76lcudu	f	0
22	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186628/ceramax/producto/bandeja-de-huevo/imagenes/aushwdmtgwek5giid0xm.jpg	ceramax/producto/bandeja-de-huevo/imagenes/aushwdmtgwek5giid0xm	f	0
23	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186631/ceramax/producto/bandeja-de-huevo/imagenes/gwimhdxcd7mkqgohnwgo.jpg	ceramax/producto/bandeja-de-huevo/imagenes/gwimhdxcd7mkqgohnwgo	f	0
24	209	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790186633/ceramax/producto/bandeja-de-huevo/imagenes/r7guugstnj99ut1conle.jpg	ceramax/producto/bandeja-de-huevo/imagenes/r7guugstnj99ut1conle	f	0
25	210	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790187044/ceramax/producto/juego-de-platos-para-postre/imagenes/ppjtddnfgdnbco0pulnh.avif	ceramax/producto/juego-de-platos-para-postre/imagenes/ppjtddnfgdnbco0pulnh	t	0
26	210	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790187047/ceramax/producto/juego-de-platos-para-postre/imagenes/q7mf1h9zkb5zhhfe0faq.avif	ceramax/producto/juego-de-platos-para-postre/imagenes/q7mf1h9zkb5zhhfe0faq	f	0
27	210	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790187049/ceramax/producto/juego-de-platos-para-postre/imagenes/ckt6akh2sx0h8wx0eegd.avif	ceramax/producto/juego-de-platos-para-postre/imagenes/ckt6akh2sx0h8wx0eegd	f	0
28	210	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790187050/ceramax/producto/juego-de-platos-para-postre/imagenes/hwmvkfzbodimkowfhglh.avif	ceramax/producto/juego-de-platos-para-postre/imagenes/hwmvkfzbodimkowfhglh	f	0
29	210	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790187052/ceramax/producto/juego-de-platos-para-postre/imagenes/fo8f7kydq3kelftsmzko.avif	ceramax/producto/juego-de-platos-para-postre/imagenes/fo8f7kydq3kelftsmzko	f	0
30	211	\N	https://res.cloudinary.com/dfmveqhud/image/upload/v1790187696/ceramax/producto/taza-de-ceramica-vintage/imagenes/v73ykona8lhy7nkavcnh.avif	ceramax/producto/taza-de-ceramica-vintage/imagenes/v73ykona8lhy7nkavcnh	t	0
\.


--
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.inventario (id_inventario, id_variante, id_almacen, cantidad_disponible, cantidad_reservada, stock_minimo, stock_maximo, punto_reorden, permite_reposicion, ultima_actualizacion) FROM stdin;
208	113	5	2	0	12	\N	0	t	2026-09-23 16:19:40.70678
210	115	5	0	0	0	\N	0	t	2026-09-23 13:10:46.312242
209	114	5	0	0	0	\N	0	t	2026-09-23 13:03:31.154115
211	116	5	0	0	0	\N	0	t	2026-09-23 13:21:38.566603
207	112	5	96	0	12	\N	0	t	2026-09-28 19:09:37.440196
\.


--
-- Data for Name: lista_deseos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.lista_deseos (id_lista_deseos, id_usuario, id_variante, fecha_agregado) FROM stdin;
\.


--
-- Data for Name: marcas; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.marcas (id_marca, nombre, descripcion, logo_url, sitio_web, estado) FROM stdin;
1	dixon ceramax	modelo hecho por ceramax	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5XU8kaD65eQtywYJAqSpqJlBTESP7Wf20VpsWofeOQw&s=10	https://www.rappi.com.co/tiendas/900376149-dixton-mt-enc	activo
\.


--
-- Data for Name: metodos_pago; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.metodos_pago (id_metodo_pago, nombre, estado) FROM stdin;
1	Tarjeta de crédito/débito	activo
2	Yape	activo
3	Efectivo	activo
\.


--
-- Data for Name: movimientos_inventario; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.movimientos_inventario (id_movimiento, id_inventario, tipo_movimiento, cantidad, cantidad_antes, cantidad_despues, motivo, referencia_documento, id_usuario_responsable, fecha_movimiento) FROM stdin;
4	207	entrada	100	0	100	sss		\N	2026-09-23 11:17:21.470261
5	208	entrada	12	0	12	sss		\N	2026-09-23 11:19:19.376132
6	208	salida	10	12	2	2sss		\N	2026-09-23 11:19:41.528608
7	207	salida	3	100	97	Salida automática por venta	PED-AFB39779	1	2026-09-23 12:32:28.027065
8	207	salida	1	97	96	Salida automática por venta	PED-DE450F75	1	2026-09-28 14:09:38.999456
\.


--
-- Data for Name: notificaciones; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.notificaciones (id_notificacion, id_usuario_destino, titulo, mensaje, tipo, entidad_referencia, entidad_id, leida, fecha_creacion) FROM stdin;
6	1	Venta registrada	La venta PED-AFB39779 por S/ 177.42 se registró correctamente	VENTA	VENTA	15	t	2026-09-23 12:32:28.439329
5	1	Venta registrada	La venta PED-C8E26886 por S/ 153.88 se registró correctamente	VENTA	VENTA	14	t	2026-09-23 12:24:10.457105
4	1	Venta registrada	La venta PED-FD86D4F1 por S/ 156.88 se registró correctamente	VENTA	VENTA	13	t	2026-09-23 11:37:44.529173
3	1	Stock bajo	Plato de foca quedó con 2 unidades en Almacen Central Lima	STOCK	INVENTARIO	208	t	2026-09-23 11:19:41.407854
7	1	Venta registrada	La venta PED-DE450F75 por S/ 74.14 se registró correctamente	VENTA	VENTA	16	f	2026-09-28 14:09:39.243157
\.


--
-- Data for Name: ordenes_compra; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.ordenes_compra (id_orden_compra, id_proveedor, id_almacen_destino, fecha_orden, fecha_recepcion_estimada, estado, total, id_usuario_creador) FROM stdin;
\.


--
-- Data for Name: pagos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.pagos (id_pago, id_pedido, id_metodo_pago, monto, estado_pago, referencia_transaccion, pasarela_pago, fecha_pago) FROM stdin;
14	16	2	74.14	completado	\N	VENTA_TIENDA	2026-09-28 14:09:39.121795
\.


--
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.pedidos (id_pedido, numero_pedido, id_usuario, id_vendedor, canal_venta, tipo_entrega, nombre_cliente_invitado, telefono_cliente_invitado, documento_cliente_invitado, id_cupon, subtotal, descuento, costo_envio, impuestos, total, estado, notas, fecha_pedido, fecha_actualizacion, tipo_comprobante, ruc_cliente, razon_social_cliente, email_cliente_invitado, nombre_receptor, documento_receptor, direccion_envio_texto, id_sucursal_recojo, id_cliente, tipo_documento_cliente_snapshot, direccion_cliente_snapshot, departamento_cliente_snapshot, provincia_cliente_snapshot, distrito_cliente_snapshot, referencia_cliente_snapshot, codigo_postal_cliente_snapshot, ciudad_cliente_snapshot, pais_cliente_snapshot) FROM stdin;
16	PED-DE450F75	\N	1	tienda_fisica	delivery	jose marcos	938473847	37475865	\N	50.12	0.00	15.00	9.02	74.14	entregado	\N	2026-09-28 14:09:38.636184	2026-09-28 20:20:17.074808	BOLETA	\N	\N	jose@gmail.com	marcos	84737475	av. los martines, Referencia: al costado, Barranco, Lima , Lima, C.P. 1736	\N	6	DNI	av. los martines	Lima	Lima	Barranco	al costado	1736	\N	\N
\.


--
-- Data for Name: permisos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.permisos (id_permiso, nombre_permiso, descripcion, activo) FROM stdin;
1	PRODUCTOS_VER	Consultar productos	activo
2	PRODUCTOS_CREAR	Crear productos	activo
3	PRODUCTOS_EDITAR	Editar productos	activo
4	PRODUCTOS_ELIMINAR	Eliminar productos	activo
5	PRODUCTOS_MARCAR_DESTACADO	Marcar o quitar productos destacados	activo
6	VARIANTES_VER	Consultar variantes de productos	activo
7	VARIANTES_CREAR	Crear variantes de productos	activo
8	VARIANTES_EDITAR	Editar variantes de productos	activo
9	VARIANTES_ELIMINAR	Eliminar variantes de productos	activo
10	VARIANTES_ASIGNAR_ATRIBUTOS	Asignar valores de atributos a variantes	activo
11	IMAGENES_VER	Consultar imágenes	activo
12	IMAGENES_CREAR	Subir imágenes	activo
13	IMAGENES_EDITAR	Reemplazar o modificar imágenes	activo
14	IMAGENES_ELIMINAR	Eliminar imágenes	activo
15	IMAGENES_MARCAR_PRINCIPAL	Marcar una imagen como principal	activo
16	UPLOAD_PRODUCTOS	Subir archivos de productos	activo
17	UPLOAD_CATEGORIAS	Subir archivos de categorías	activo
18	UPLOAD_ELIMINAR	Eliminar archivos subidos	activo
19	CATEGORIAS_VER	Consultar categorías	activo
20	CATEGORIAS_CREAR	Crear categorías	activo
21	CATEGORIAS_EDITAR	Editar categorías	activo
22	CATEGORIAS_ELIMINAR	Eliminar categorías	activo
23	CATEGORIA_ATRIBUTOS_VER	Consultar atributos de una categoría	activo
24	CATEGORIA_ATRIBUTOS_ASIGNAR	Asignar atributos a una categoría	activo
25	CATEGORIA_ATRIBUTOS_ELIMINAR	Quitar atributos de una categoría	activo
26	ATRIBUTOS_VER	Consultar atributos	activo
27	ATRIBUTOS_CREAR	Crear atributos	activo
28	ATRIBUTOS_EDITAR	Editar atributos	activo
29	ATRIBUTOS_ELIMINAR	Eliminar atributos	activo
30	VALORES_ATRIBUTOS_VER	Consultar valores de atributos	activo
31	VALORES_ATRIBUTOS_CREAR	Crear valores de atributos	activo
32	VALORES_ATRIBUTOS_EDITAR	Editar valores de atributos	activo
33	VALORES_ATRIBUTOS_ELIMINAR	Eliminar valores de atributos	activo
34	INVENTARIO_VER	Consultar inventario	activo
35	INVENTARIO_CREAR	Crear registros de inventario	activo
36	INVENTARIO_EDITAR	Editar registros de inventario	activo
37	INVENTARIO_ELIMINAR	Eliminar registros de inventario	activo
38	INVENTARIO_BAJO_STOCK_VER	Consultar productos con bajo stock	activo
39	MOVIMIENTOS_VER	Consultar movimientos de inventario	activo
40	MOVIMIENTOS_CREAR	Registrar movimientos de inventario	activo
41	ALMACENES_VER	Consultar almacenes	activo
42	ALMACENES_CREAR	Crear almacenes	activo
43	ALMACENES_EDITAR	Editar almacenes	activo
44	ALMACENES_ELIMINAR	Eliminar almacenes	activo
45	VENTAS_VER	Consultar ventas	activo
46	VENTAS_CREAR	Crear ventas	activo
47	VENTAS_EDITAR	Editar ventas	activo
48	VENTAS_CAMBIAR_ESTADO	Cambiar estado de ventas	activo
49	PAGOS_VER	Consultar pagos	activo
50	PAGOS_CREAR	Registrar pagos	activo
51	PAGOS_CAMBIAR_ESTADO	Cambiar estado de pagos	activo
52	ENVIOS_VER	Consultar envíos	activo
53	ENVIOS_CREAR	Crear envíos	activo
54	ENVIOS_CAMBIAR_ESTADO	Cambiar estado de envíos	activo
55	DEVOLUCIONES_VER	Consultar devoluciones	activo
56	DEVOLUCIONES_CREAR	Crear devoluciones	activo
57	DEVOLUCIONES_CAMBIAR_ESTADO	Cambiar estado de devoluciones	activo
58	ORDENES_COMPRA_VER	Consultar órdenes de compra	activo
59	ORDENES_COMPRA_CREAR	Crear órdenes de compra	activo
60	ORDENES_COMPRA_CAMBIAR_ESTADO	Cambiar estado de órdenes de compra	activo
61	CUPONES_VER	Consultar cupones	activo
62	CUPONES_CREAR	Crear cupones	activo
63	CUPONES_EDITAR	Editar cupones	activo
64	CUPONES_ELIMINAR	Eliminar cupones	activo
65	RESEÑAS_VER	Consultar reseñas	activo
66	RESEÑAS_CREAR	Crear reseñas	activo
67	RESEÑAS_CAMBIAR_ESTADO	Cambiar estado de reseñas	activo
68	RESEÑAS_ELIMINAR	Eliminar reseñas	activo
69	MARCAS_VER	Consultar marcas	activo
70	MARCAS_CREAR	Crear marcas	activo
71	MARCAS_EDITAR	Editar marcas	activo
72	MARCAS_ELIMINAR	Eliminar marcas	activo
73	PROVEEDORES_VER	Consultar proveedores	activo
74	PROVEEDORES_CREAR	Crear proveedores	activo
75	PROVEEDORES_EDITAR	Editar proveedores	activo
76	PROVEEDORES_ELIMINAR	Eliminar proveedores	activo
77	SUCURSALES_VER	Consultar sucursales	activo
78	SUCURSALES_CREAR	Crear sucursales	activo
79	SUCURSALES_EDITAR	Editar sucursales	activo
80	SUCURSALES_ELIMINAR	Eliminar sucursales	activo
81	TRANSPORTISTAS_VER	Consultar transportistas	activo
82	TRANSPORTISTAS_CREAR	Crear transportistas	activo
83	TRANSPORTISTAS_EDITAR	Editar transportistas	activo
84	TRANSPORTISTAS_ELIMINAR	Eliminar transportistas	activo
85	METODOS_PAGO_VER	Consultar métodos de pago	activo
86	METODOS_PAGO_CREAR	Crear métodos de pago	activo
87	METODOS_PAGO_EDITAR	Editar métodos de pago	activo
88	METODOS_PAGO_ELIMINAR	Eliminar métodos de pago	activo
89	CONFIGURACION_VER	Consultar configuración	activo
90	CONFIGURACION_EDITAR	Editar configuración	activo
91	USUARIOS_VER	Consultar usuarios	activo
92	USUARIOS_CREAR	Crear usuarios	activo
93	USUARIOS_EDITAR	Editar usuarios	activo
94	USUARIOS_ELIMINAR	Eliminar usuarios	activo
95	ROLES_VER	Consultar roles	activo
96	ROLES_CREAR	Crear roles	activo
97	ROLES_EDITAR	Editar roles	activo
98	ROLES_ELIMINAR	Eliminar roles	activo
99	PERMISOS_VER	Consultar permisos	activo
100	PERMISOS_CREAR	Crear permisos	activo
101	PERMISOS_ELIMINAR	Eliminar permisos	activo
102	AUDITORIA_VER	Consultar auditoría	activo
103	NOTIFICACIONES_VER	Consultar notificaciones	activo
104	NOTIFICACIONES_MARCAR_LEIDA	Marcar notificaciones como leídas	activo
105	NOTIFICACIONES_ELIMINAR	Eliminar notificaciones	activo
106	REPORTES_VER	Consultar reportes	activo
107	REPORTES_RESUMEN	Consultar resumen de reportes	activo
108	REPORTES_DASHBOARD	Consultar dashboard de reportes	activo
109	REPORTES_VENTAS_VENDEDOR	Consultar ventas por vendedor	activo
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.productos (id_producto, sku, id_categoria, id_marca, id_proveedor, nombre, descripcion_corta, descripcion, precio_base, costo, descuento_porcentaje, especificaciones, destacado, tiene_descuento, fecha_caducidad, requiere_envio_fisico, estado, meta_titulo, meta_descripcion, creado_por, actualizado_por, fecha_creacion, fecha_actualizacion) FROM stdin;
206	SC-001	25	\N	\N	Plato de foca		1 pieza CMYD Studio Adorable cuenco de cerámica con forma de foca con borde, apto para desayuno, avena, plato de postre, frutero, regalo de vajilla - Linda foca 	50.12	36.27	12.00	{"Medidas": "15.5cm x 18.5cm", "Material": "Cerámica", "Funciones especiales": "Apto para microondas"}	f	f	\N	t	activo	plato de forma foca	plato bonito blanco	\N	\N	2026-09-23 08:09:39.286963	2026-09-23 17:55:54.270024
209	SC-002	25	\N	\N	Bandeja de Huevo	Bandeja de Huevo de Cerámica con Campana de Árbol de Navidad	1pc Bandeja de Huevo de Cerámica con Campana de Árbol de Navidad, Exquisita Bandeja de Huevo con Estampado de Estrella de Corona de Navidad de Alta Calidad, Adecuada para Decoración del Hogar, Taza de Huevo para Decoración de Mesa de Cocina en el Hogar, Vajilla de Ambiente Navideño, Regalo	20.20	0.00	28.69	{"tamaño": "6.5cm x 5.2cm", "Material": "Cerámica"}	f	t	\N	t	activo	Bandeja de Huevo | Sala y comedor | CeraMax	1pc Bandeja de Huevo de Cerámica con Campana de Árbol de Navidad, Exquisita Bandeja de Huevo con Estampado de Estrella de Corona de Navidad de Alta Calidad, Adecuada para Decoración del Hogar, Taza de Huevo para Decoración de Mesa de Cocina en el Hogar, Vajilla de Ambiente Navideño, Regalo	\N	\N	2026-09-23 13:03:30.307704	2026-09-23 13:03:30.307704
210	SC003	25	\N	\N	juego de platos para postre	juego de platos para postre florales exquisitos de 3 niveles	Nuevo juego de platos para postre florales exquisitos de 3 niveles, hecho de plástico PP duradero para uso multiusos. Diseño romántico que mejora el ambiente de tu mesa de comedor. Ideal para soportes de pastel de boda, bandejas de postre, platos de frutas y varios artículos para fiestas. Perfecto	62.07	0.00	70.00	{"Material": "Plástico", "Fuente de alimentacion": "Uso sin electricidad"}	f	t	\N	t	activo	juego de platos para postre | Sala y comedor | CeraMax	Nuevo juego de platos para postre florales exquisitos de 3 niveles, hecho de plástico PP duradero para uso multiusos. Diseño romántico que mejora el ambiente de tu mesa de comedor. Ideal para soportes de pastel de boda, bandejas de postre, platos de frutas y varios artículos para fiestas. Perfecto	\N	\N	2026-09-23 13:10:45.493758	2026-09-23 13:10:45.493758
211	SCT001	27	\N	\N	Taza de cerámica vintage	 taza de gres presenta un diseño de cerámica rústica	Esta taza de gres presenta un diseño de cerámica rústica de estilo vintage, perfecta para añadir un toque tradicional a tu ritual matutino de café o té. Su textura única realza su estética artesanal.	15.00	0.00	10.00	{"forma": "rotundidad", "Material": "Cerámico", "embalaje": "caja de cartón", "capacidad": "101-200 ml", "Tipo de vasos": "Tazas", "Sustancia química altamente preocupante": "ninguno"}	f	t	\N	t	activo	Taza de cerámica vintage | Accesorios para cafe | CeraMax	Esta taza de gres presenta un diseño de cerámica rústica de estilo vintage, perfecta para añadir un toque tradicional a tu ritual matutino de café o té. Su textura única realza su estética artesanal.	\N	\N	2026-09-23 13:21:37.859945	2026-09-23 13:21:37.859945
\.


--
-- Data for Name: proveedores; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.proveedores (id_proveedor, nombre_empresa, contacto_nombre, email, telefono, direccion, condiciones_pago, estado) FROM stdin;
1	dortes	dortes	dortex@gmail.com	987654321	miraflores	31	activo
\.


--
-- Data for Name: resenas; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.resenas (id_resena, id_producto, id_usuario, id_pedido, calificacion, titulo, comentario, estado, fecha_resena) FROM stdin;
\.


--
-- Data for Name: rol_permisos; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.rol_permisos (id_rol, id_permiso, activo) FROM stdin;
1	1	t
1	2	t
1	3	t
1	4	t
1	5	t
1	6	t
1	7	t
1	8	t
1	9	t
1	10	t
1	11	t
1	12	t
1	13	t
1	14	t
1	15	t
1	16	t
1	17	t
1	18	t
1	19	t
1	20	t
1	21	t
1	22	t
1	23	t
1	24	t
1	25	t
1	26	t
1	27	t
1	28	t
1	29	t
1	30	t
1	31	t
1	32	t
1	33	t
1	34	t
1	35	t
1	36	t
1	37	t
1	38	t
1	39	t
1	40	t
1	41	t
1	42	t
1	43	t
1	44	t
1	45	t
1	46	t
1	47	t
1	48	t
1	49	t
1	50	t
1	51	t
1	52	t
1	53	t
1	54	t
1	55	t
1	56	t
1	57	t
1	58	t
1	59	t
1	60	t
1	61	t
1	62	t
1	63	t
1	64	t
1	65	t
1	66	t
1	67	t
1	68	t
1	69	t
1	70	t
1	71	t
1	72	t
1	73	t
1	74	t
1	75	t
1	76	t
1	77	t
1	78	t
1	79	t
1	80	t
1	81	t
1	82	t
1	83	t
1	84	t
1	85	t
1	86	t
1	87	t
1	88	t
1	89	t
1	90	t
1	91	t
1	92	t
1	93	t
1	94	t
1	95	t
1	96	t
1	97	t
1	98	t
1	99	t
1	100	t
1	101	t
1	102	t
1	103	t
1	104	t
1	105	t
1	106	t
1	107	t
1	108	t
1	109	t
2	1	t
2	2	t
2	3	t
2	5	t
2	6	t
2	7	t
2	8	t
2	10	t
2	11	t
2	12	t
2	13	t
2	15	t
2	19	t
2	23	t
2	26	t
2	30	t
2	34	t
2	35	t
2	36	t
2	38	t
2	39	t
2	40	t
2	41	t
2	45	t
2	46	t
2	47	t
2	48	t
2	49	t
2	50	t
2	51	t
2	52	t
2	53	t
2	54	t
2	55	t
2	56	t
2	57	t
2	58	t
2	59	t
2	60	t
2	61	t
2	65	t
2	67	t
2	69	t
2	73	t
2	77	t
2	81	t
2	85	t
2	89	t
2	103	t
2	104	t
2	106	t
2	107	t
2	109	t
3	1	t
3	6	t
3	11	t
3	19	t
3	23	t
3	26	t
3	30	t
3	45	t
3	46	t
3	49	t
3	50	t
3	52	t
3	55	t
3	56	t
3	61	t
3	65	t
3	66	t
3	103	t
3	104	t
4	1	t
4	2	t
4	3	t
4	4	t
4	5	t
4	6	t
4	7	t
4	8	t
4	9	t
4	10	t
4	11	t
4	12	t
4	13	t
4	14	t
4	15	t
4	19	t
4	20	t
4	21	t
4	22	t
4	23	t
4	24	t
4	25	t
4	26	t
4	27	t
4	28	t
4	29	t
4	30	t
4	31	t
4	32	t
4	33	t
4	34	t
4	35	t
4	36	t
4	37	t
4	38	t
4	39	t
4	40	t
4	41	t
4	42	t
4	43	t
4	44	t
4	52	t
4	53	t
4	54	t
4	69	t
4	70	t
4	71	t
4	72	t
4	73	t
4	74	t
4	75	t
4	76	t
4	77	t
4	78	t
4	79	t
4	80	t
4	81	t
4	82	t
4	83	t
4	84	t
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.roles (id_rol, nombre_rol, descripcion, activo) FROM stdin;
1	ADMIN	Administración completa del sistema	activo
2	VENDEDOR	Operación de ventas e inventario	activo
3	CLIENTE	Cliente de la tienda	activo
4	LOGISTICA	Gestión de catálogo, inventario y operaciones logísticas	activo
\.


--
-- Data for Name: sucursales; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.sucursales (id_sucursal, nombre, direccion, distrito, departamento, referencia, codigo_postal, telefono, email, horario_atencion, latitud, longitud, permite_recojo, permite_delivery, estado) FROM stdin;
2	Sucursal Principal	Av. Principal 123	Centro	Lima	\N	\N	\N	\N	\N	\N	\N	t	t	activo
\.


--
-- Data for Name: tokens_invalidados; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.tokens_invalidados (id_token_invalidado, token_hash, fecha_expiracion, fecha_invalidacion) FROM stdin;
\.


--
-- Data for Name: transportistas; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.transportistas (id_transportista, nombre, sitio_rastreo_url, estado) FROM stdin;
1	Olva Currier	\N	activo
2	Shalom	\N	activo
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.usuarios (id_usuario, nombre, apellido, email, password_hash, tipo_documento, numero_documento, telefono, fecha_nacimiento, fecha_registro, fecha_actualizacion, fecha_eliminacion, rol, imagen_url, estado, intentos_login_fallidos) FROM stdin;
1	Administrador	CeraMax	admin@ceramax.com	$2a$10$LhgGim88M7ZLtpMUq21YT.7BIR/NlZ4MprriNLOscigQrOwnYF86i	\N	\N	\N	\N	2026-09-09 22:15:26.685829	2026-09-12 18:21:17.502713	\N	ADMIN	\N	activo	0
2	Vendedor	CeraMax	vendedor@ceramax.com	$2a$10$iQgv.UwuUrsR0KC5qVDCZu0INOfBFBsAxIyBuwm4hG3ee9t6dxCq2	\N	\N	\N	\N	2026-09-09 22:15:26.685829	2026-09-14 05:00:14.273895	\N	VENDEDOR	\N	activo	0
10	Axel	Ronal	ax3847@ceramax.pe	$2a$10$ImS5/Jqg./lsm9.4FByDJOy0BtxHO5F9PMLJZTe4oKsfG7r6gn2yy	DNI	38475582	983746574	\N	2026-09-28 12:58:46.893756	2026-09-28 18:46:45.057094	\N	LOGISTICA	\N	activo	0
\.


--
-- Data for Name: valores_atributo; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.valores_atributo (id_valor, id_atributo, valor) FROM stdin;
5	3	Negro
7	3	Multicolor
10	3	Blanco
11	3	Beige
12	3	Azul
17	3	Rojo
18	3	Amarillo
19	3	Naranja
20	3	Marrón
21	3	Rosado
22	3	Púrpura
23	3	Gris
24	6	Navidad
25	6	Halloween
26	6	Día de la Madre
27	6	Día del Padre
28	7	Redondo
29	7	Oval
30	7	Rectangular
31	7	Cuadrado
32	7	Foca
34	3	Verde
35	12	Grande
36	12	Mediano
37	12	Pequeño
39	7	Pez
40	7	Rectángulo
\.


--
-- Data for Name: variante_atributo_valor; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.variante_atributo_valor (id_variante, id_valor) FROM stdin;
113	35
112	10
112	32
113	10
113	32
112	36
114	10
114	29
114	24
114	36
115	10
115	29
115	26
115	36
116	19
116	29
\.


--
-- Data for Name: variantes_producto; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.variantes_producto (id_variante, id_producto, sku_variante, codigo_barras, precio_adicional, estado) FROM stdin;
112	206	SVC001	\N	0.00	activo
113	206	SVC002	\N	20.00	activo
114	209	SVCH001	\N	0.00	activo
115	210	SC003	\N	0.00	activo
116	211	SVT001	\N	0.00	activo
\.


--
-- Name: almacenes_id_almacen_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.almacenes_id_almacen_seq', 8, true);


--
-- Name: atributos_id_atributo_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.atributos_id_atributo_seq', 13, true);


--
-- Name: auditorias_id_auditoria_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.auditorias_id_auditoria_seq', 212, true);


--
-- Name: carritos_id_carrito_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.carritos_id_carrito_seq', 8, true);


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.categorias_id_categoria_seq', 27, true);


--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.clientes_id_cliente_seq', 6, true);


--
-- Name: cupones_id_cupon_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.cupones_id_cupon_seq', 1, true);


--
-- Name: detalle_carrito_id_detalle_carrito_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.detalle_carrito_id_detalle_carrito_seq', 18, true);


--
-- Name: detalle_orden_compra_id_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.detalle_orden_compra_id_detalle_seq', 1, true);


--
-- Name: detalle_pedido_id_detalle_pedido_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.detalle_pedido_id_detalle_pedido_seq', 19, true);


--
-- Name: devoluciones_id_devolucion_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.devoluciones_id_devolucion_seq', 1, false);


--
-- Name: direcciones_id_direccion_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.direcciones_id_direccion_seq', 6, true);


--
-- Name: envios_id_envio_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.envios_id_envio_seq', 8, true);


--
-- Name: imagenes_categoria_id_imagen_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.imagenes_categoria_id_imagen_categoria_seq', 6, true);


--
-- Name: imagenes_producto_id_imagen_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.imagenes_producto_id_imagen_seq', 30, true);


--
-- Name: inventario_id_inventario_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.inventario_id_inventario_seq', 211, true);


--
-- Name: lista_deseos_id_lista_deseos_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.lista_deseos_id_lista_deseos_seq', 2, true);


--
-- Name: marcas_id_marca_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.marcas_id_marca_seq', 1, true);


--
-- Name: metodos_pago_id_metodo_pago_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.metodos_pago_id_metodo_pago_seq', 3, true);


--
-- Name: movimientos_inventario_id_movimiento_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.movimientos_inventario_id_movimiento_seq', 8, true);


--
-- Name: notificaciones_id_notificacion_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.notificaciones_id_notificacion_seq', 7, true);


--
-- Name: ordenes_compra_id_orden_compra_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.ordenes_compra_id_orden_compra_seq', 2, true);


--
-- Name: pagos_id_pago_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.pagos_id_pago_seq', 14, true);


--
-- Name: pedidos_id_pedido_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.pedidos_id_pedido_seq', 16, true);


--
-- Name: permisos_id_permiso_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.permisos_id_permiso_seq', 109, true);


--
-- Name: productos_id_producto_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.productos_id_producto_seq', 211, true);


--
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.proveedores_id_proveedor_seq', 2, true);


--
-- Name: resenas_id_resena_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.resenas_id_resena_seq', 1, false);


--
-- Name: roles_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.roles_id_rol_seq', 4, true);


--
-- Name: sucursales_id_sucursal_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.sucursales_id_sucursal_seq', 3, true);


--
-- Name: tokens_invalidados_id_token_invalidado_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.tokens_invalidados_id_token_invalidado_seq', 34, true);


--
-- Name: transportistas_id_transportista_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.transportistas_id_transportista_seq', 2, true);


--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 10, true);


--
-- Name: valores_atributo_id_valor_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.valores_atributo_id_valor_seq', 40, true);


--
-- Name: variantes_producto_id_variante_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.variantes_producto_id_variante_seq', 116, true);


--
-- Name: almacenes almacenes_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.almacenes
    ADD CONSTRAINT almacenes_pkey PRIMARY KEY (id_almacen);


--
-- Name: atributos atributos_nombre_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.atributos
    ADD CONSTRAINT atributos_nombre_key UNIQUE (nombre);


--
-- Name: atributos atributos_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.atributos
    ADD CONSTRAINT atributos_pkey PRIMARY KEY (id_atributo);


--
-- Name: auditorias auditorias_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.auditorias
    ADD CONSTRAINT auditorias_pkey PRIMARY KEY (id_auditoria);


--
-- Name: carritos carritos_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.carritos
    ADD CONSTRAINT carritos_pkey PRIMARY KEY (id_carrito);


--
-- Name: categoria_atributos categoria_atributos_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.categoria_atributos
    ADD CONSTRAINT categoria_atributos_pkey PRIMARY KEY (id_categoria, id_atributo);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- Name: categorias categorias_slug_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_slug_key UNIQUE (slug);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- Name: configuracion_tienda configuracion_tienda_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.configuracion_tienda
    ADD CONSTRAINT configuracion_tienda_pkey PRIMARY KEY (id_configuracion);


--
-- Name: cupones cupones_codigo_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.cupones
    ADD CONSTRAINT cupones_codigo_key UNIQUE (codigo);


--
-- Name: cupones cupones_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.cupones
    ADD CONSTRAINT cupones_pkey PRIMARY KEY (id_cupon);


--
-- Name: detalle_carrito detalle_carrito_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_carrito
    ADD CONSTRAINT detalle_carrito_pkey PRIMARY KEY (id_detalle_carrito);


--
-- Name: detalle_orden_compra detalle_orden_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_orden_compra
    ADD CONSTRAINT detalle_orden_compra_pkey PRIMARY KEY (id_detalle);


--
-- Name: detalle_pedido detalle_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_pkey PRIMARY KEY (id_detalle_pedido);


--
-- Name: devoluciones devoluciones_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.devoluciones
    ADD CONSTRAINT devoluciones_pkey PRIMARY KEY (id_devolucion);


--
-- Name: direcciones direcciones_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_pkey PRIMARY KEY (id_direccion);


--
-- Name: envios envios_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.envios
    ADD CONSTRAINT envios_pkey PRIMARY KEY (id_envio);


--
-- Name: imagenes_categoria imagenes_categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imagenes_categoria
    ADD CONSTRAINT imagenes_categoria_pkey PRIMARY KEY (id_imagen_categoria);


--
-- Name: imagenes_producto imagenes_producto_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imagenes_producto
    ADD CONSTRAINT imagenes_producto_pkey PRIMARY KEY (id_imagen);


--
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_inventario);


--
-- Name: lista_deseos lista_deseos_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.lista_deseos
    ADD CONSTRAINT lista_deseos_pkey PRIMARY KEY (id_lista_deseos);


--
-- Name: marcas marcas_nombre_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marcas_nombre_key UNIQUE (nombre);


--
-- Name: marcas marcas_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marcas_pkey PRIMARY KEY (id_marca);


--
-- Name: metodos_pago metodos_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.metodos_pago
    ADD CONSTRAINT metodos_pago_pkey PRIMARY KEY (id_metodo_pago);


--
-- Name: movimientos_inventario movimientos_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_pkey PRIMARY KEY (id_movimiento);


--
-- Name: notificaciones notificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id_notificacion);


--
-- Name: ordenes_compra ordenes_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.ordenes_compra
    ADD CONSTRAINT ordenes_compra_pkey PRIMARY KEY (id_orden_compra);


--
-- Name: pagos pagos_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_pkey PRIMARY KEY (id_pago);


--
-- Name: pedidos pedidos_numero_pedido_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_numero_pedido_key UNIQUE (numero_pedido);


--
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id_pedido);


--
-- Name: permisos permisos_nombre_permiso_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT permisos_nombre_permiso_key UNIQUE (nombre_permiso);


--
-- Name: permisos permisos_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (id_permiso);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);


--
-- Name: productos productos_sku_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_sku_key UNIQUE (sku);


--
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_proveedor);


--
-- Name: resenas resenas_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.resenas
    ADD CONSTRAINT resenas_pkey PRIMARY KEY (id_resena);


--
-- Name: rol_permisos rol_permisos_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.rol_permisos
    ADD CONSTRAINT rol_permisos_pkey PRIMARY KEY (id_rol, id_permiso);


--
-- Name: roles roles_nombre_rol_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_rol_key UNIQUE (nombre_rol);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_rol);


--
-- Name: sucursales sucursales_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.sucursales
    ADD CONSTRAINT sucursales_pkey PRIMARY KEY (id_sucursal);


--
-- Name: tokens_invalidados tokens_invalidados_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.tokens_invalidados
    ADD CONSTRAINT tokens_invalidados_pkey PRIMARY KEY (id_token_invalidado);


--
-- Name: tokens_invalidados tokens_invalidados_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.tokens_invalidados
    ADD CONSTRAINT tokens_invalidados_token_hash_key UNIQUE (token_hash);


--
-- Name: transportistas transportistas_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.transportistas
    ADD CONSTRAINT transportistas_pkey PRIMARY KEY (id_transportista);


--
-- Name: clientes uq_clientes_documento; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT uq_clientes_documento UNIQUE (tipo_documento, numero_documento);


--
-- Name: clientes uq_clientes_email; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT uq_clientes_email UNIQUE (email);


--
-- Name: detalle_carrito uq_detalle_carrito; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_carrito
    ADD CONSTRAINT uq_detalle_carrito UNIQUE (id_carrito, id_variante);


--
-- Name: inventario uq_inventario_variante_almacen; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT uq_inventario_variante_almacen UNIQUE (id_variante, id_almacen);


--
-- Name: lista_deseos uq_lista_deseos; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.lista_deseos
    ADD CONSTRAINT uq_lista_deseos UNIQUE (id_usuario, id_variante);


--
-- Name: resenas uq_resenas_usuario_producto_pedido; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.resenas
    ADD CONSTRAINT uq_resenas_usuario_producto_pedido UNIQUE (id_usuario, id_producto, id_pedido);


--
-- Name: valores_atributo uq_valor_atributo; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.valores_atributo
    ADD CONSTRAINT uq_valor_atributo UNIQUE (id_atributo, valor);


--
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- Name: usuarios usuarios_numero_documento_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_numero_documento_key UNIQUE (numero_documento);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- Name: valores_atributo valores_atributo_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.valores_atributo
    ADD CONSTRAINT valores_atributo_pkey PRIMARY KEY (id_valor);


--
-- Name: variante_atributo_valor variante_atributo_valor_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.variante_atributo_valor
    ADD CONSTRAINT variante_atributo_valor_pkey PRIMARY KEY (id_variante, id_valor);


--
-- Name: variantes_producto variantes_producto_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.variantes_producto
    ADD CONSTRAINT variantes_producto_pkey PRIMARY KEY (id_variante);


--
-- Name: variantes_producto variantes_producto_sku_variante_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.variantes_producto
    ADD CONSTRAINT variantes_producto_sku_variante_key UNIQUE (sku_variante);


--
-- Name: idx_almacenes_estado_recojo; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_almacenes_estado_recojo ON public.almacenes USING btree (estado, permite_recojo_cliente);


--
-- Name: idx_almacenes_recojo; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_almacenes_recojo ON public.almacenes USING btree (permite_recojo_cliente);


--
-- Name: idx_auditorias_accion_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_auditorias_accion_fecha ON public.auditorias USING btree (accion, fecha_auditoria DESC);


--
-- Name: idx_auditorias_entidad_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_auditorias_entidad_fecha ON public.auditorias USING btree (entidad, fecha_auditoria DESC);


--
-- Name: idx_auditorias_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_auditorias_fecha ON public.auditorias USING btree (fecha_auditoria DESC);


--
-- Name: idx_auditorias_usuario_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_auditorias_usuario_fecha ON public.auditorias USING btree (id_usuario, fecha_auditoria DESC);


--
-- Name: idx_carritos_session_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_carritos_session_estado ON public.carritos USING btree (session_id, estado);


--
-- Name: idx_carritos_usuario_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_carritos_usuario_estado ON public.carritos USING btree (id_usuario, estado);


--
-- Name: idx_categoria_atributos_atributo; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_categoria_atributos_atributo ON public.categoria_atributos USING btree (id_atributo);


--
-- Name: idx_categorias_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_categorias_estado ON public.categorias USING btree (estado);


--
-- Name: idx_categorias_nombre; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_categorias_nombre ON public.categorias USING btree (nombre);


--
-- Name: idx_categorias_padre; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_categorias_padre ON public.categorias USING btree (id_categoria_padre);


--
-- Name: idx_cupones_estado_fechas; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_cupones_estado_fechas ON public.cupones USING btree (estado, fecha_inicio, fecha_fin);


--
-- Name: idx_detalle_carrito_carrito; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_detalle_carrito_carrito ON public.detalle_carrito USING btree (id_carrito);


--
-- Name: idx_detalle_carrito_variante; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_detalle_carrito_variante ON public.detalle_carrito USING btree (id_variante);


--
-- Name: idx_detalle_orden_compra_orden; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_detalle_orden_compra_orden ON public.detalle_orden_compra USING btree (id_orden_compra);


--
-- Name: idx_detalle_orden_compra_variante; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_detalle_orden_compra_variante ON public.detalle_orden_compra USING btree (id_variante);


--
-- Name: idx_detalle_pedido_almacen; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_detalle_pedido_almacen ON public.detalle_pedido USING btree (id_almacen);


--
-- Name: idx_detalle_pedido_pedido; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_detalle_pedido_pedido ON public.detalle_pedido USING btree (id_pedido);


--
-- Name: idx_detalle_pedido_variante; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_detalle_pedido_variante ON public.detalle_pedido USING btree (id_variante);


--
-- Name: idx_devoluciones_detalle; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_devoluciones_detalle ON public.devoluciones USING btree (id_detalle_pedido);


--
-- Name: idx_devoluciones_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_devoluciones_estado ON public.devoluciones USING btree (estado);


--
-- Name: idx_devoluciones_pedido; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_devoluciones_pedido ON public.devoluciones USING btree (id_pedido);


--
-- Name: idx_direcciones_usuario; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_direcciones_usuario ON public.direcciones USING btree (id_usuario);


--
-- Name: idx_direcciones_usuario_predeterminada; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_direcciones_usuario_predeterminada ON public.direcciones USING btree (id_usuario, es_predeterminada);


--
-- Name: idx_envios_numero_seguimiento; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_envios_numero_seguimiento ON public.envios USING btree (numero_seguimiento);


--
-- Name: idx_envios_pedido; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_envios_pedido ON public.envios USING btree (id_pedido);


--
-- Name: idx_envios_transportista; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_envios_transportista ON public.envios USING btree (id_transportista);


--
-- Name: idx_imagenes_categoria_categoria; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_imagenes_categoria_categoria ON public.imagenes_categoria USING btree (id_categoria);


--
-- Name: idx_imagenes_categoria_orden; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_imagenes_categoria_orden ON public.imagenes_categoria USING btree (id_categoria, orden);


--
-- Name: idx_imagenes_producto_orden; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_imagenes_producto_orden ON public.imagenes_producto USING btree (id_producto, orden);


--
-- Name: idx_imagenes_producto_principal; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_imagenes_producto_principal ON public.imagenes_producto USING btree (id_producto, orden) WHERE (es_principal = true);


--
-- Name: idx_imagenes_producto_producto; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_imagenes_producto_producto ON public.imagenes_producto USING btree (id_producto);


--
-- Name: idx_imagenes_producto_variante; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_imagenes_producto_variante ON public.imagenes_producto USING btree (id_variante);


--
-- Name: idx_inventario_almacen; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_inventario_almacen ON public.inventario USING btree (id_almacen);


--
-- Name: idx_lista_deseos_usuario; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_lista_deseos_usuario ON public.lista_deseos USING btree (id_usuario);


--
-- Name: idx_lista_deseos_variante; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_lista_deseos_variante ON public.lista_deseos USING btree (id_variante);


--
-- Name: idx_marcas_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_marcas_estado ON public.marcas USING btree (estado);


--
-- Name: idx_metodos_pago_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_metodos_pago_estado ON public.metodos_pago USING btree (estado);


--
-- Name: idx_movimientos_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_movimientos_fecha ON public.movimientos_inventario USING btree (fecha_movimiento);


--
-- Name: idx_movimientos_inventario; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_movimientos_inventario ON public.movimientos_inventario USING btree (id_inventario);


--
-- Name: idx_movimientos_tipo_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_movimientos_tipo_fecha ON public.movimientos_inventario USING btree (tipo_movimiento, fecha_movimiento);


--
-- Name: idx_movimientos_usuario; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_movimientos_usuario ON public.movimientos_inventario USING btree (id_usuario_responsable);


--
-- Name: idx_notificaciones_usuario_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_notificaciones_usuario_fecha ON public.notificaciones USING btree (id_usuario_destino, fecha_creacion);


--
-- Name: idx_notificaciones_usuario_no_leida; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_notificaciones_usuario_no_leida ON public.notificaciones USING btree (id_usuario_destino, leida);


--
-- Name: idx_ordenes_compra_almacen; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_ordenes_compra_almacen ON public.ordenes_compra USING btree (id_almacen_destino);


--
-- Name: idx_ordenes_compra_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_ordenes_compra_estado ON public.ordenes_compra USING btree (estado);


--
-- Name: idx_ordenes_compra_proveedor; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_ordenes_compra_proveedor ON public.ordenes_compra USING btree (id_proveedor);


--
-- Name: idx_ordenes_compra_usuario; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_ordenes_compra_usuario ON public.ordenes_compra USING btree (id_usuario_creador);


--
-- Name: idx_pagos_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_pagos_estado ON public.pagos USING btree (estado_pago);


--
-- Name: idx_pagos_metodo; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_pagos_metodo ON public.pagos USING btree (id_metodo_pago);


--
-- Name: idx_pagos_pedido; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_pagos_pedido ON public.pagos USING btree (id_pedido);


--
-- Name: idx_pedidos_cupon; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_pedidos_cupon ON public.pedidos USING btree (id_cupon);


--
-- Name: idx_pedidos_estado_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_pedidos_estado_fecha ON public.pedidos USING btree (estado, fecha_pedido);


--
-- Name: idx_pedidos_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_pedidos_fecha ON public.pedidos USING btree (fecha_pedido);


--
-- Name: idx_pedidos_sucursal_recojo; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_pedidos_sucursal_recojo ON public.pedidos USING btree (id_sucursal_recojo);


--
-- Name: idx_pedidos_usuario_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_pedidos_usuario_fecha ON public.pedidos USING btree (id_usuario, fecha_pedido);


--
-- Name: idx_pedidos_vendedor_fecha; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_pedidos_vendedor_fecha ON public.pedidos USING btree (id_vendedor, fecha_pedido);


--
-- Name: idx_permisos_activo; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_permisos_activo ON public.permisos USING btree (activo);


--
-- Name: idx_productos_actualizado_por; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_actualizado_por ON public.productos USING btree (actualizado_por);


--
-- Name: idx_productos_categoria; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_categoria ON public.productos USING btree (id_categoria);


--
-- Name: idx_productos_creado_por; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_creado_por ON public.productos USING btree (creado_por);


--
-- Name: idx_productos_destacado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_destacado ON public.productos USING btree (destacado);


--
-- Name: idx_productos_estado_destacado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_estado_destacado ON public.productos USING btree (estado, destacado);


--
-- Name: idx_productos_marca; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_marca ON public.productos USING btree (id_marca);


--
-- Name: idx_productos_nombre_lower; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_nombre_lower ON public.productos USING btree (lower((nombre)::text));


--
-- Name: idx_productos_nombre_trgm; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_nombre_trgm ON public.productos USING gin (lower((nombre)::text) public.gin_trgm_ops);


--
-- Name: idx_productos_proveedor; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_proveedor ON public.productos USING btree (id_proveedor);


--
-- Name: idx_productos_sku_trgm; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_productos_sku_trgm ON public.productos USING gin (lower((sku)::text) public.gin_trgm_ops);


--
-- Name: idx_proveedores_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_proveedores_estado ON public.proveedores USING btree (estado);


--
-- Name: idx_resenas_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_resenas_estado ON public.resenas USING btree (estado);


--
-- Name: idx_resenas_pedido; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_resenas_pedido ON public.resenas USING btree (id_pedido);


--
-- Name: idx_resenas_producto; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_resenas_producto ON public.resenas USING btree (id_producto);


--
-- Name: idx_resenas_usuario; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_resenas_usuario ON public.resenas USING btree (id_usuario);


--
-- Name: idx_rol_permisos_permiso; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_rol_permisos_permiso ON public.rol_permisos USING btree (id_permiso);


--
-- Name: idx_roles_activo; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_roles_activo ON public.roles USING btree (activo);


--
-- Name: idx_sucursales_delivery; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_sucursales_delivery ON public.sucursales USING btree (permite_delivery);


--
-- Name: idx_sucursales_distrito; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_sucursales_distrito ON public.sucursales USING btree (distrito);


--
-- Name: idx_sucursales_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_sucursales_estado ON public.sucursales USING btree (estado);


--
-- Name: idx_sucursales_recojo; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_sucursales_recojo ON public.sucursales USING btree (permite_recojo);


--
-- Name: idx_tokens_invalidados_expiracion; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_tokens_invalidados_expiracion ON public.tokens_invalidados USING btree (fecha_expiracion);


--
-- Name: idx_transportistas_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_transportistas_estado ON public.transportistas USING btree (estado);


--
-- Name: idx_usuarios_no_eliminados; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_usuarios_no_eliminados ON public.usuarios USING btree (id_usuario) WHERE (fecha_eliminacion IS NULL);


--
-- Name: idx_usuarios_rol_estado; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_usuarios_rol_estado ON public.usuarios USING btree (rol, estado);


--
-- Name: idx_valores_atributo_atributo; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_valores_atributo_atributo ON public.valores_atributo USING btree (id_atributo);


--
-- Name: idx_variante_atributo_valor_valor; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_variante_atributo_valor_valor ON public.variante_atributo_valor USING btree (id_valor);


--
-- Name: idx_variantes_codigo_barras; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_variantes_codigo_barras ON public.variantes_producto USING btree (codigo_barras);


--
-- Name: idx_variantes_producto; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX idx_variantes_producto ON public.variantes_producto USING btree (id_producto);


--
-- Name: uq_clientes_dni; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX uq_clientes_dni ON public.clientes USING btree (btrim((numero_documento)::text)) WHERE ((upper(btrim((tipo_documento)::text)) = 'DNI'::text) AND (NULLIF(btrim((numero_documento)::text), ''::text) IS NOT NULL));


--
-- Name: uq_clientes_email_ci; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX uq_clientes_email_ci ON public.clientes USING btree (lower(btrim((email)::text))) WHERE (NULLIF(btrim((email)::text), ''::text) IS NOT NULL);


--
-- Name: uq_clientes_razon_social; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX uq_clientes_razon_social ON public.clientes USING btree (lower(btrim((razon_social)::text))) WHERE (NULLIF(btrim((razon_social)::text), ''::text) IS NOT NULL);


--
-- Name: uq_clientes_ruc; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX uq_clientes_ruc ON public.clientes USING btree (btrim((ruc)::text)) WHERE (NULLIF(btrim((ruc)::text), ''::text) IS NOT NULL);


--
-- Name: uq_clientes_telefono; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX uq_clientes_telefono ON public.clientes USING btree (btrim((telefono)::text)) WHERE (NULLIF(btrim((telefono)::text), ''::text) IS NOT NULL);


--
-- Name: carritos trg_carritos_fecha_actualizacion; Type: TRIGGER; Schema: public; Owner: neondb_owner
--

CREATE TRIGGER trg_carritos_fecha_actualizacion BEFORE UPDATE ON public.carritos FOR EACH ROW EXECUTE FUNCTION public.set_fecha_actualizacion();


--
-- Name: inventario trg_inventario_ultima_actualizacion; Type: TRIGGER; Schema: public; Owner: neondb_owner
--

CREATE TRIGGER trg_inventario_ultima_actualizacion BEFORE UPDATE ON public.inventario FOR EACH ROW EXECUTE FUNCTION public.set_ultima_actualizacion();


--
-- Name: pedidos trg_pedidos_fecha_actualizacion; Type: TRIGGER; Schema: public; Owner: neondb_owner
--

CREATE TRIGGER trg_pedidos_fecha_actualizacion BEFORE UPDATE ON public.pedidos FOR EACH ROW EXECUTE FUNCTION public.set_fecha_actualizacion();


--
-- Name: productos trg_productos_fecha_actualizacion; Type: TRIGGER; Schema: public; Owner: neondb_owner
--

CREATE TRIGGER trg_productos_fecha_actualizacion BEFORE UPDATE ON public.productos FOR EACH ROW EXECUTE FUNCTION public.set_fecha_actualizacion();


--
-- Name: usuarios trg_usuarios_fecha_actualizacion; Type: TRIGGER; Schema: public; Owner: neondb_owner
--

CREATE TRIGGER trg_usuarios_fecha_actualizacion BEFORE UPDATE ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.set_fecha_actualizacion();


--
-- Name: auditorias auditorias_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.auditorias
    ADD CONSTRAINT auditorias_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- Name: carritos carritos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.carritos
    ADD CONSTRAINT carritos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- Name: categoria_atributos categoria_atributos_id_atributo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.categoria_atributos
    ADD CONSTRAINT categoria_atributos_id_atributo_fkey FOREIGN KEY (id_atributo) REFERENCES public.atributos(id_atributo) ON DELETE CASCADE;


--
-- Name: categoria_atributos categoria_atributos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.categoria_atributos
    ADD CONSTRAINT categoria_atributos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id_categoria) ON DELETE CASCADE;


--
-- Name: categorias categorias_id_categoria_padre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_id_categoria_padre_fkey FOREIGN KEY (id_categoria_padre) REFERENCES public.categorias(id_categoria);


--
-- Name: detalle_carrito detalle_carrito_id_carrito_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_carrito
    ADD CONSTRAINT detalle_carrito_id_carrito_fkey FOREIGN KEY (id_carrito) REFERENCES public.carritos(id_carrito);


--
-- Name: detalle_carrito detalle_carrito_id_variante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_carrito
    ADD CONSTRAINT detalle_carrito_id_variante_fkey FOREIGN KEY (id_variante) REFERENCES public.variantes_producto(id_variante) ON DELETE CASCADE;


--
-- Name: detalle_orden_compra detalle_orden_compra_id_orden_compra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_orden_compra
    ADD CONSTRAINT detalle_orden_compra_id_orden_compra_fkey FOREIGN KEY (id_orden_compra) REFERENCES public.ordenes_compra(id_orden_compra);


--
-- Name: detalle_orden_compra detalle_orden_compra_id_variante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_orden_compra
    ADD CONSTRAINT detalle_orden_compra_id_variante_fkey FOREIGN KEY (id_variante) REFERENCES public.variantes_producto(id_variante) ON DELETE SET NULL;


--
-- Name: detalle_pedido detalle_pedido_id_almacen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_id_almacen_fkey FOREIGN KEY (id_almacen) REFERENCES public.almacenes(id_almacen);


--
-- Name: detalle_pedido detalle_pedido_id_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id_pedido);


--
-- Name: detalle_pedido detalle_pedido_id_variante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.detalle_pedido
    ADD CONSTRAINT detalle_pedido_id_variante_fkey FOREIGN KEY (id_variante) REFERENCES public.variantes_producto(id_variante) ON DELETE SET NULL;


--
-- Name: devoluciones devoluciones_id_detalle_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.devoluciones
    ADD CONSTRAINT devoluciones_id_detalle_pedido_fkey FOREIGN KEY (id_detalle_pedido) REFERENCES public.detalle_pedido(id_detalle_pedido);


--
-- Name: devoluciones devoluciones_id_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.devoluciones
    ADD CONSTRAINT devoluciones_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id_pedido);


--
-- Name: direcciones direcciones_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.direcciones
    ADD CONSTRAINT direcciones_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- Name: envios envios_id_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.envios
    ADD CONSTRAINT envios_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id_pedido);


--
-- Name: envios envios_id_transportista_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.envios
    ADD CONSTRAINT envios_id_transportista_fkey FOREIGN KEY (id_transportista) REFERENCES public.transportistas(id_transportista);


--
-- Name: pedidos fk_pedidos_sucursal_recojo; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT fk_pedidos_sucursal_recojo FOREIGN KEY (id_sucursal_recojo) REFERENCES public.sucursales(id_sucursal);


--
-- Name: imagenes_categoria imagenes_categoria_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imagenes_categoria
    ADD CONSTRAINT imagenes_categoria_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id_categoria) ON DELETE CASCADE;


--
-- Name: imagenes_producto imagenes_producto_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imagenes_producto
    ADD CONSTRAINT imagenes_producto_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto) ON DELETE CASCADE;


--
-- Name: imagenes_producto imagenes_producto_id_variante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.imagenes_producto
    ADD CONSTRAINT imagenes_producto_id_variante_fkey FOREIGN KEY (id_variante) REFERENCES public.variantes_producto(id_variante) ON DELETE CASCADE;


--
-- Name: inventario inventario_id_almacen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_id_almacen_fkey FOREIGN KEY (id_almacen) REFERENCES public.almacenes(id_almacen);


--
-- Name: inventario inventario_id_variante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_id_variante_fkey FOREIGN KEY (id_variante) REFERENCES public.variantes_producto(id_variante) ON DELETE CASCADE;


--
-- Name: lista_deseos lista_deseos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.lista_deseos
    ADD CONSTRAINT lista_deseos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- Name: lista_deseos lista_deseos_id_variante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.lista_deseos
    ADD CONSTRAINT lista_deseos_id_variante_fkey FOREIGN KEY (id_variante) REFERENCES public.variantes_producto(id_variante) ON DELETE CASCADE;


--
-- Name: movimientos_inventario movimientos_inventario_id_inventario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_id_inventario_fkey FOREIGN KEY (id_inventario) REFERENCES public.inventario(id_inventario) ON DELETE CASCADE;


--
-- Name: movimientos_inventario movimientos_inventario_id_usuario_responsable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_id_usuario_responsable_fkey FOREIGN KEY (id_usuario_responsable) REFERENCES public.usuarios(id_usuario);


--
-- Name: notificaciones notificaciones_id_usuario_destino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_id_usuario_destino_fkey FOREIGN KEY (id_usuario_destino) REFERENCES public.usuarios(id_usuario);


--
-- Name: ordenes_compra ordenes_compra_id_almacen_destino_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.ordenes_compra
    ADD CONSTRAINT ordenes_compra_id_almacen_destino_fkey FOREIGN KEY (id_almacen_destino) REFERENCES public.almacenes(id_almacen);


--
-- Name: ordenes_compra ordenes_compra_id_proveedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.ordenes_compra
    ADD CONSTRAINT ordenes_compra_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES public.proveedores(id_proveedor);


--
-- Name: ordenes_compra ordenes_compra_id_usuario_creador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.ordenes_compra
    ADD CONSTRAINT ordenes_compra_id_usuario_creador_fkey FOREIGN KEY (id_usuario_creador) REFERENCES public.usuarios(id_usuario);


--
-- Name: pagos pagos_id_metodo_pago_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_id_metodo_pago_fkey FOREIGN KEY (id_metodo_pago) REFERENCES public.metodos_pago(id_metodo_pago);


--
-- Name: pagos pagos_id_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pagos
    ADD CONSTRAINT pagos_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id_pedido);


--
-- Name: pedidos pedidos_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente);


--
-- Name: pedidos pedidos_id_cupon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_id_cupon_fkey FOREIGN KEY (id_cupon) REFERENCES public.cupones(id_cupon);


--
-- Name: pedidos pedidos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- Name: pedidos pedidos_id_vendedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_id_vendedor_fkey FOREIGN KEY (id_vendedor) REFERENCES public.usuarios(id_usuario);


--
-- Name: productos productos_actualizado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_actualizado_por_fkey FOREIGN KEY (actualizado_por) REFERENCES public.usuarios(id_usuario);


--
-- Name: productos productos_creado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_creado_por_fkey FOREIGN KEY (creado_por) REFERENCES public.usuarios(id_usuario);


--
-- Name: productos productos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id_categoria);


--
-- Name: productos productos_id_marca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_marca_fkey FOREIGN KEY (id_marca) REFERENCES public.marcas(id_marca);


--
-- Name: productos productos_id_proveedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES public.proveedores(id_proveedor);


--
-- Name: resenas resenas_id_pedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.resenas
    ADD CONSTRAINT resenas_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id_pedido);


--
-- Name: resenas resenas_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.resenas
    ADD CONSTRAINT resenas_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto) ON DELETE CASCADE;


--
-- Name: resenas resenas_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.resenas
    ADD CONSTRAINT resenas_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- Name: rol_permisos rol_permisos_id_permiso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.rol_permisos
    ADD CONSTRAINT rol_permisos_id_permiso_fkey FOREIGN KEY (id_permiso) REFERENCES public.permisos(id_permiso);


--
-- Name: rol_permisos rol_permisos_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.rol_permisos
    ADD CONSTRAINT rol_permisos_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.roles(id_rol);


--
-- Name: valores_atributo valores_atributo_id_atributo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.valores_atributo
    ADD CONSTRAINT valores_atributo_id_atributo_fkey FOREIGN KEY (id_atributo) REFERENCES public.atributos(id_atributo) ON DELETE CASCADE;


--
-- Name: variante_atributo_valor variante_atributo_valor_id_valor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.variante_atributo_valor
    ADD CONSTRAINT variante_atributo_valor_id_valor_fkey FOREIGN KEY (id_valor) REFERENCES public.valores_atributo(id_valor) ON DELETE CASCADE;


--
-- Name: variante_atributo_valor variante_atributo_valor_id_variante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.variante_atributo_valor
    ADD CONSTRAINT variante_atributo_valor_id_variante_fkey FOREIGN KEY (id_variante) REFERENCES public.variantes_producto(id_variante) ON DELETE CASCADE;


--
-- Name: variantes_producto variantes_producto_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.variantes_producto
    ADD CONSTRAINT variantes_producto_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: neondb_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict gedOJb4wel3T10GqgTz0zpJCdVDShV8ptB1vMEHcuUdpLbWSI7e3wtVtndT1Sfi
