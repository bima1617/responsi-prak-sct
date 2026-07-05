// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SertifikatTanah {

    address public admin;

    constructor(){
        admin = msg.sender;
    }

    struct Sertifikat{
        string nomorSertifikat;
        string namaPemilik;
        string lokasiTanah;
        uint luasTanah;
        bytes32 hashDokumen;
        uint tanggalTerdaftar;
        bool valid;
    }

    mapping(bytes32 => Sertifikat) private daftarSertifikat;

    event SertifikatDitambahkan(bytes32 hashDokumen, string nomor, string pemilik);

    modifier hanyaAdmin(){
        require(msg.sender == admin, "Hanya admin yang bisa menambah data");
        _;
    }

    function tambahSertifikat(
        string memory _nomor,
        string memory _pemilik,
        string memory _lokasi,
        uint _luas,
        bytes32 _hash
    ) public hanyaAdmin {

        require(daftarSertifikat[_hash].tanggalTerdaftar == 0, "Sertifikat sudah ada");

        daftarSertifikat[_hash] = Sertifikat(
            _nomor,
            _pemilik,
            _lokasi,
            _luas,
            _hash,
            block.timestamp,
            true
        );

        emit SertifikatDitambahkan(_hash,_nomor,_pemilik);
    }

    function verifikasiSertifikat(bytes32 _hash)
    public view returns(
        string memory nomor,
        string memory pemilik,
        string memory lokasi,
        uint luas,
        uint tanggal,
        bool status
    ){

        Sertifikat memory s = daftarSertifikat[_hash];

        if(s.tanggalTerdaftar == 0){
            return ("Tidak ditemukan","-","-",0,0,false);
        }

        return(
            s.nomorSertifikat,
            s.namaPemilik,
            s.lokasiTanah,
            s.luasTanah,
            s.tanggalTerdaftar,
            s.valid
        );
    }
}