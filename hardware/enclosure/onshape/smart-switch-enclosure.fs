FeatureScript 3132;
import(path : "onshape/std/common.fs", version : "3132.0");

// Smart switch enclosure: UNPOWERED FIT PROTOTYPE. All numbers are millimetres.
// Lid carries four BESTTEN LD-3012TR decorator receptacles in one row (lid acts as
// the wall plate). Left wall carries the Acouto C14 inlet with switch (42 x 27 mm
// cutout, 50 mm hole pitch). See hardware/enclosure/selected-connectors.md.
// Seller-stated dimensions; measure received parts before final cuts.
// Not a mains-rated housing. No load rating is established for this geometry.

const MM = millimeter;

function mmBox(context is Context, id is Id, x1, y1, z1, x2, y2, z2)
{
    fCuboid(context, id, { "corner1" : vector(x1, y1, z1) * MM, "corner2" : vector(x2, y2, z2) * MM });
    return qCreatedBy(id, EntityType.BODY);
}

function mmCyl(context is Context, id is Id, p1 is array, p2 is array, d)
{
    fCylinder(context, id, {
            "bottomCenter" : vector(p1[0], p1[1], p1[2]) * MM,
            "topCenter" : vector(p2[0], p2[1], p2[2]) * MM,
            "radius" : (d / 2) * MM });
    return qCreatedBy(id, EntityType.BODY);
}

annotation { "Feature Type Name" : "Smart Switch Enclosure",
             "Feature Type Description" : "Fit-check enclosure: four decorator receptacles in the lid, C14 inlet with switch in the left wall, relay standoffs, controller bay. Unpowered prototype geometry." }
export const smartSwitchEnclosure = defineFeature(function(context is Context, id is Id, definition is map)
    precondition
    {
        annotation { "Name" : "Outer length X" }
        isLength(definition.outerX, { (millimeter) : [180, 235, 400] } as LengthBoundSpec);
        annotation { "Name" : "Outer width Y" }
        isLength(definition.outerY, { (millimeter) : [140, 180, 400] } as LengthBoundSpec);
        annotation { "Name" : "Base height" }
        isLength(definition.baseH, { (millimeter) : [50, 70, 150] } as LengthBoundSpec);
        annotation { "Name" : "Wall and floor thickness" }
        isLength(definition.wall, { (millimeter) : [2, 4, 8] } as LengthBoundSpec);
        annotation { "Name" : "Lid thickness" }
        isLength(definition.lidT, { (millimeter) : [4, 6, 10] } as LengthBoundSpec);
        annotation { "Name" : "Outlet pitch" }
        isLength(definition.outletPitch, { (millimeter) : [40, 46.04, 80] } as LengthBoundSpec);
        annotation { "Name" : "Controller bay width" }
        isLength(definition.bayW, { (millimeter) : [30, 40, 80] } as LengthBoundSpec);
        annotation { "Name" : "Fuse holder holes", "Default" : true }
        definition.fuseHoles is boolean;
        annotation { "Name" : "Fuse hole diameter" }
        isLength(definition.fuseD, { (millimeter) : [8, 12.7, 20] } as LengthBoundSpec);
        annotation { "Name" : "Lid explode distance" }
        isLength(definition.explode, { (millimeter) : [0, 25, 100] } as LengthBoundSpec);
    }
    {
        const X = definition.outerX / MM;
        const Y = definition.outerY / MM;
        const H = definition.baseH / MM;
        const w = definition.wall / MM;
        const lidT = definition.lidT / MM;
        const pitch = definition.outletPitch / MM;
        const bayW = definition.bayW / MM;
        const fuseD = definition.fuseD / MM;
        const explode = definition.explode / MM;

        // Decorator receptacle: BESTTEN listing plus the standard NEMA decorator pattern.
        const openW = 33.3;            // opening across the row
        const openL = 66.8;            // opening along the strap
        const plateScrewPitch = 96.8;  // 6-32 plate screws into the device
        const yokePitch = 83.3;        // 6-32 yoke screws, blind pilots from inside
        const plateScrewD = 3.7;
        const yokePilotD = 2.8;
        // Inlet: Acouto C14 with rocker switch, long axis horizontal.
        const inletW = 42;
        const inletH = 27;
        const inletPitch = 50;
        const inletHoleD = 3.5;
        const inletY = Y / 2;
        const inletZ = 35;
        const padT = 2;                // wall + pad = 6 mm mounting panel
        const padHalfY = 36;
        // Relay module from the user's sketch; hole offsets are provisional.
        const relayL = 72.64;
        const relayW = 49.27;
        const relayOff = 2.85;
        const relayX = 60;
        const relayY = 65;
        const standoffH = 5;
        const standoffD = 6.5;
        const pilotD = 2.5;
        // Posts, lid screws, divider.
        const postD = 8;
        const postInset = 6;
        const lidScrewD = 3.4;
        const postPilotDepth = 12;
        const divT = 2.4;
        const divX = X - w - bayW - divT;
        const rowCx = (w + divX) / 2;
        const postXY = [[postInset, postInset], [X - postInset, postInset],
                        [postInset, Y - postInset], [X - postInset, Y - postInset],
                        [X / 2, postInset], [X / 2, Y - postInset]];
        const lidZ = H + explode;
        const relayHoles = [[relayOff, relayOff], [relayL - relayOff, relayOff],
                            [relayOff, relayW - relayOff], [relayL - relayOff, relayW - relayOff]];

        // ---- Base: shell plus additive details ----
        mmBox(context, id + "outer", 0, 0, 0, X, Y, H);
        mmBox(context, id + "cavity", w, w, w, X - w, Y - w, H + 1);
        opBoolean(context, id + "hollow", {
                "tools" : qCreatedBy(id + "cavity", EntityType.BODY),
                "targets" : qCreatedBy(id + "outer", EntityType.BODY),
                "operationType" : BooleanOperationType.SUBTRACTION });
        for (var i = 0; i < size(postXY); i += 1)
        {
            mmCyl(context, id + ("post" ~ i), [postXY[i][0], postXY[i][1], 0], [postXY[i][0], postXY[i][1], H], postD);
        }
        for (var i = 0; i < 4; i += 1)
        {
            const hx = relayX + relayHoles[i][0];
            const hy = relayY + relayHoles[i][1];
            mmCyl(context, id + ("standoff" ~ i), [hx, hy, 0], [hx, hy, w + standoffH], standoffD);
        }
        mmBox(context, id + "divider", divX, w - 0.01, w - 0.01, divX + divT, Y - w + 0.01, H - 2);
        mmBox(context, id + "inletPad", w - 0.01, inletY - padHalfY, w - 0.01, w + padT, inletY + padHalfY, H - 4);
        opBoolean(context, id + "baseUnion", {
                "tools" : qCreatedBy(id, EntityType.BODY),
                "operationType" : BooleanOperationType.UNION });

        // ---- Base: cutters ----
        var cut = [];
        for (var i = 0; i < size(postXY); i += 1)
        {
            cut = append(cut, mmCyl(context, id + ("postPilot" ~ i),
                    [postXY[i][0], postXY[i][1], H - postPilotDepth], [postXY[i][0], postXY[i][1], H + 1], pilotD));
        }
        for (var i = 0; i < 4; i += 1)
        {
            const hx = relayX + relayHoles[i][0];
            const hy = relayY + relayHoles[i][1];
            cut = append(cut, mmCyl(context, id + ("relayPilot" ~ i), [hx, hy, w], [hx, hy, w + standoffH + 1], pilotD));
        }
        cut = append(cut, mmBox(context, id + "inletCut", -1, inletY - inletW / 2, inletZ - inletH / 2,
                w + padT + 1, inletY + inletW / 2, inletZ + inletH / 2));
        cut = append(cut, mmCyl(context, id + "inletHole0",
                [-1, inletY - inletPitch / 2, inletZ], [w + padT + 1, inletY - inletPitch / 2, inletZ], inletHoleD));
        cut = append(cut, mmCyl(context, id + "inletHole1",
                [-1, inletY + inletPitch / 2, inletZ], [w + padT + 1, inletY + inletPitch / 2, inletZ], inletHoleD));
        if (definition.fuseHoles)
        {
            // One panel-mount fuse holder in the front wall under each outlet. Confirm the
            // holder's own cutout (round hole plus anti-rotation flat) before printing.
            for (var i = 0; i < 4; i += 1)
            {
                const cx = rowCx + (i - 1.5) * pitch;
                cut = append(cut, mmCyl(context, id + ("fuse" ~ i), [cx, -1, inletZ], [cx, w + 1, inletZ], fuseD));
            }
        }
        cut = append(cut, mmCyl(context, id + "lvHole", [X - w - 1, 65, 23], [X + 1, 65, 23], 12.1));
        const bayCx = X - w - bayW / 2;
        cut = append(cut, mmBox(context, id + "usb", bayCx - 7, Y - w - 1, 8, bayCx + 7, Y + 1, 16));
        cut = append(cut, mmBox(context, id + "pass", divX - 1, Y / 2 - 6, 14, divX + divT + 1, Y / 2 + 6, 22));
        const baseCutters = qUnion(cut);
        opBoolean(context, id + "baseCut", {
                "tools" : baseCutters,
                "targets" : qSubtraction(qCreatedBy(id, EntityType.BODY), baseCutters),
                "operationType" : BooleanOperationType.SUBTRACTION });

        // ---- Lid: plate, locating lip, receptacle openings ----
        const lidId = id + "lid";
        const lipC = 0.3;
        const lipT = 1.6;
        const lipH = 2;
        const li = w + lipC;
        mmBox(context, lidId + "plate", 0, 0, lidZ, X, Y, lidZ + lidT);
        mmBox(context, lidId + "lip0", li, li, lidZ - lipH, X - li, li + lipT, lidZ + 0.01);
        mmBox(context, lidId + "lip1", li, Y - li - lipT, lidZ - lipH, X - li, Y - li, lidZ + 0.01);
        mmBox(context, lidId + "lip2", li, li, lidZ - lipH, li + lipT, Y - li, lidZ + 0.01);
        mmBox(context, lidId + "lip3", X - li - lipT, li, lidZ - lipH, X - li, Y - li, lidZ + 0.01);
        opBoolean(context, lidId + "union", {
                "tools" : qCreatedBy(lidId, EntityType.BODY),
                "operationType" : BooleanOperationType.UNION });
        var lc = [];
        for (var i = 0; i < 4; i += 1)
        {
            const cx = rowCx + (i - 1.5) * pitch;
            lc = append(lc, mmBox(context, lidId + ("open" ~ i), cx - openW / 2, Y / 2 - openL / 2, lidZ - 1,
                    cx + openW / 2, Y / 2 + openL / 2, lidZ + lidT + 1));
            for (var s = -1; s <= 1; s += 2)
            {
                const py = Y / 2 + s * plateScrewPitch / 2;
                const yy = Y / 2 + s * yokePitch / 2;
                lc = append(lc, mmCyl(context, lidId + ("plateScrew" ~ i ~ (s + 1)),
                        [cx, py, lidZ - 1], [cx, py, lidZ + lidT + 1], plateScrewD));
                lc = append(lc, mmCyl(context, lidId + ("yokePilot" ~ i ~ (s + 1)),
                        [cx, yy, lidZ - 1], [cx, yy, lidZ + lidT - 1], yokePilotD));
            }
        }
        for (var i = 0; i < size(postXY); i += 1)
        {
            lc = append(lc, mmCyl(context, lidId + ("screw" ~ i),
                    [postXY[i][0], postXY[i][1], lidZ - 1], [postXY[i][0], postXY[i][1], lidZ + lidT + 1], lidScrewD));
            lc = append(lc, mmCyl(context, lidId + ("postClear" ~ i),
                    [postXY[i][0], postXY[i][1], lidZ - lipH - 1], [postXY[i][0], postXY[i][1], lidZ], postD + 2 * lipC));
        }
        const lidCutters = qUnion(lc);
        opBoolean(context, lidId + "cut", {
                "tools" : lidCutters,
                "targets" : qSubtraction(qCreatedBy(lidId, EntityType.BODY), lidCutters),
                "operationType" : BooleanOperationType.SUBTRACTION });

        setProperty(context, {
                "entities" : qSubtraction(qCreatedBy(id, EntityType.BODY), qCreatedBy(lidId, EntityType.BODY)),
                "propertyType" : PropertyType.NAME,
                "value" : "Base" });
        setProperty(context, {
                "entities" : qCreatedBy(lidId, EntityType.BODY),
                "propertyType" : PropertyType.NAME,
                "value" : "Lid" });
    });
