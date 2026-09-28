-- Add delivery milestones to the order enum. Each new label must be committed
-- before it can be stored in a row.
BEGIN;
ALTER TYPE public.estadopedidoenum
    ADD VALUE IF NOT EXISTS 'en_transporte' AFTER 'pendiente';
COMMIT;

BEGIN;
ALTER TYPE public.estadopedidoenum
    ADD VALUE IF NOT EXISTS 'en_ruta' AFTER 'en_transporte';
COMMIT;

BEGIN;

-- Preserve delivery-address history in order snapshots before removing links
-- to mutable customer addresses.
UPDATE public.pedidos p
SET direccion_envio_texto = COALESCE(
        NULLIF(BTRIM(p.direccion_envio_texto), ''),
        NULLIF(CONCAT_WS(', ',
            NULLIF(BTRIM(d.calle), ''),
            NULLIF(BTRIM(d.numero_ext), ''),
            NULLIF(BTRIM(d.colonia_sector), ''),
            NULLIF(BTRIM(d.ciudad), ''),
            NULLIF(BTRIM(d.estado_provincia), ''),
            NULLIF(BTRIM(d.codigo_postal), ''),
            NULLIF(BTRIM(d.pais), '')
        ), '')
    ),
    direccion_cliente_snapshot = COALESCE(
        p.direccion_cliente_snapshot,
        NULLIF(CONCAT_WS(', ',
            NULLIF(BTRIM(d.calle), ''),
            NULLIF(BTRIM(d.numero_ext), ''),
            NULLIF(BTRIM(d.colonia_sector), '')
        ), '')
    ),
    provincia_cliente_snapshot = COALESCE(p.provincia_cliente_snapshot, d.estado_provincia),
    distrito_cliente_snapshot = COALESCE(p.distrito_cliente_snapshot, d.ciudad),
    ciudad_cliente_snapshot = COALESCE(p.ciudad_cliente_snapshot, d.ciudad),
    codigo_postal_cliente_snapshot = COALESCE(p.codigo_postal_cliente_snapshot, d.codigo_postal),
    pais_cliente_snapshot = COALESCE(p.pais_cliente_snapshot, d.pais),
    telefono_cliente_invitado = COALESCE(p.telefono_cliente_invitado, d.telefono_contacto)
FROM public.direcciones d
WHERE p.id_direccion_envio = d.id_direccion
  AND p.tipo_entrega = 'delivery';

ALTER TABLE public.pedidos
    DROP CONSTRAINT IF EXISTS ck_pedidos_delivery_direccion,
    DROP CONSTRAINT IF EXISTS pedidos_id_direccion_envio_fkey,
    DROP CONSTRAINT IF EXISTS pedidos_id_direccion_facturacion_fkey,
    DROP CONSTRAINT IF EXISTS pedidos_id_almacen_recojo_fkey;

ALTER TABLE public.pedidos
    DROP COLUMN IF EXISTS id_direccion_envio,
    DROP COLUMN IF EXISTS id_direccion_facturacion,
    DROP COLUMN IF EXISTS id_almacen_recojo;

ALTER TABLE public.pedidos
    ADD CONSTRAINT ck_pedidos_delivery_direccion
    CHECK (
        tipo_entrega <> 'delivery'::public.tipoentregaenum
        OR direccion_envio_texto IS NOT NULL
    );

COMMIT;
