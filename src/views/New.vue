<template>
<el-form ref="form" :model="form" label-width="80px">
  <el-form-item label="amount" prop="amount" :rules="[
      { required: true, message: '不能为空'},
      { type: 'number', message: '必须为数字值'}
    ]">
    <el-input type="amount" v-model.number="form.amount"></el-input>
  </el-form-item>
  <el-form-item label="title" prop="title" :rules="[
      { required: true, message: '不能为空'}
    ]">
    <el-input type="title" v-model="form.title"></el-input>
  </el-form-item>
  <el-form-item label="desc" prop="desc" :rules="[
      { required: true, message: '不能为空'}
    ]">
    <el-input type="desc" v-model="form.desc"></el-input>
  </el-form-item>
  <el-form-item label="materialHash" prop="materialHash" :rules="[
      { required: true, message: '不能为空'},
      { type: 'number', message: '必须为数字值'}
    ]">
    <el-input type="materialHash" v-model.number="form.materialHash"></el-input>
  </el-form-item>
  <el-form-item label="materialUrl" prop="materialUrl" :rules="[
      { required: true, message: '不能为空'}
    ]">
    <el-input type="materialUrl" v-model="form.materialUrl"></el-input>
  </el-form-item>
  <el-form-item label="donateToAddr" prop="donateToAddr" :rules="[
      { required: true, message: '不能为空'}
    ]">
    <el-input type="donateToAddr" v-model="form.donateToAddr"></el-input>
  </el-form-item>
  <el-form-item>
    <el-button type="primary" @click="onSubmit('form')">立即创建</el-button>
    <el-button @click="resetForm('form')">取消</el-button>
  </el-form-item>
</el-form>
</template>

<script>
  export default {
    data() {
      return {
        form: {
          amount: 0,
          title: '',
          desc: '',
          materialHash: 0,
          materialUrl: '',
          donateToAddr: '',
        }
      }
    },
    methods: {
      onSubmit(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$store.dispatch('CREATE_CONTRACT', this.form)
          } else {
            console.log('error submit!!');
            return false;
          }
        });
      },
      resetForm(formName) {
        this.$refs[formName].resetFields();
      }
    }
  }
</script>
